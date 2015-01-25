//
//  ALMRequestManager.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequestManager.h"
#import "ALMResourceConstants.h"

@interface ALMRequestManager ()

@property (strong, nonatomic) NSMutableArray *taskWaitingForAuth;
@property (strong, nonatomic) NSURLSessionDataTask *loginTask;
@property (assign) BOOL isAuthtenticating;

@end

@implementation ALMRequestManager

#pragma mark - Constructors

- (id)initWithBaseURL:(NSURL *)url delegate:(id<ALMRequestManagerDelegate>)delegate {
    self = [super initWithBaseURL:url];
    if (self) {
        _requestManagerDelegate = delegate;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<ALMRequestManagerDelegate>)delegate {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        _requestManagerDelegate = delegate;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (id)initWithBaseURLString:(NSString *)urlString delegate:(id<ALMRequestManagerDelegate>)delegate {
    return [self initWithBaseURL:[NSURL URLWithString:urlString] delegate:delegate];
}

- (id)initWithBaseURLString:(NSString *)urlString sessionConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id<ALMRequestManagerDelegate>)delegate {
    return [self initWithBaseURL:[NSURL URLWithString:urlString] sessionConfiguration:configuration delegate:delegate];
}

#pragma mark - Delegate usage

- (NSString *)apiKey {
    return _requestManagerDelegate.apiKey;
}

- (RLMRealm*)temporalRealm {
    return [_requestManagerDelegate temporalRealm];
}

- (RLMRealm*)defaultRealm {
    return [_requestManagerDelegate defaultRealm];
}

- (RLMRealm *)encryptedRealm {
    return [_requestManagerDelegate encryptedRealm];
}

- (void)setHttpRequestHeaders:(NSDictionary *)headers {
    for (NSString *headerField in headers.allKeys) {
        NSString *httpHeaderValue = headers[headerField];
        [self.requestSerializer setValue:httpHeaderValue forHTTPHeaderField:headerField];
    }
}


#pragma mark - GET

- (NSURLSessionDataTask *)GET:(ALMRequest *)request {
    if (![request validateRequest]) {
        if (request.onError) {
            request.onError(nil, [NSError errorWithDomain:@"Request Manager"
                                                     code:1
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Invalid request"}]);
        }
        return nil;
    }
    
    if (request.needsAuthentication) {
        NSDictionary *headers = request.configureHttpRequestHeaders(request.session, self.apiKey);
        [self setHttpRequestHeaders:headers];
        
        if (request.customRequestTask) {
            __block ALMRequest * blockRequest = request;
            __weak typeof(self) weakSelf = self;
            
            return request.customRequestTask(weakSelf, blockRequest);
        }
        else {
            return [self performGET:request];
        }
    }
    else if (_isAuthtenticating) {
        [self.taskWaitingForAuth addObject:request];
        NSLog(@"Added request to auth queue");
        return _loginTask;
    }
    else {
        _isAuthtenticating = YES;
        __block ALMRequest * blockRequest = request;
        __weak typeof(self) weakSelf = self;
        
        [self.taskWaitingForAuth addObject:request];
        
        _loginTask = [self performLoginOperationWith:blockRequest.session onSuccess:^(NSURLSessionDataTask *task, ALMSession *session) {
            blockRequest.session = session;
           
            
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.isAuthtenticating = NO;
            for (ALMRequest *waitingRequest in strongSelf.taskWaitingForAuth) {
                NSLog(@"Performing queued request");
                [strongSelf GET:waitingRequest];
            }
            [strongSelf.taskWaitingForAuth removeAllObjects];
            
        } onFail:blockRequest.onError];
        
        return _loginTask;
    }
}


- (NSURLSessionDataTask *)performGET:(ALMRequest *)request {
    __block ALMRequest * blockRequest = request;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [request execOnLoad];
    });
    
    NSURLSessionDataTask *op = [self GET:request.path
                              parameters:request.parameters
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        id finalResponseObject = [blockRequest execFetch:task fetchedData:responseObject];
        id committed = [blockRequest execCommit:finalResponseObject];
        if (blockRequest.shouldLog) {
            NSLog(@"%@", committed);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockRequest execOnFinishWithTask:task];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error getting resource");
        if (blockRequest.onError) {
            blockRequest.onError(task, error);
        }
    }];
    
    return op;
}


#pragma mark - Login

- (NSURLSessionDataTask *)loginWith:(ALMSession *)session onSuccess:(void (^)(NSURLSessionDataTask *, ALMSession *))onSuccess onFail:(void (^)(NSURLSessionDataTask *, NSError *))onFail {
    
    NSString *realmPath = session.realm.path;
    NSString *sessionEmail = session.email;
    
    return [self performLoginOperationWith:session onSuccess:^(NSURLSessionDataTask *task, ALMSession *session) {
        if (onSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RLMRealm *realm = [RLMRealm realmWithPath:realmPath];
                ALMSession *threadSafeSession = [ALMSession sessionWithEmail:sessionEmail inRealm:realm];
                onSuccess(task, threadSafeSession);
            });
        }
    } onFail:^(NSURLSessionDataTask *task, NSError *error) {
        if (onFail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onFail(task, error);
            });
        }
    }];
}

- (NSURLSessionDataTask *)performLoginOperationWith:(ALMSession *)session
                          onSuccess:(void (^)(NSURLSessionDataTask *task, ALMSession *session))onSuccess
                             onFail:(void (^)(NSURLSessionDataTask *task, NSError *error))onFail {
    
    NSAssert(session.realm != nil, @"Session must be saved on a Realm");
    
    NSDictionary *headers = [ALMRequest defaultHttpHeaders](nil, self.apiKey);
    NSString *loginPath = [_requestManagerDelegate.sessionManager loginPostPath:session];
    NSDictionary *params = [_requestManagerDelegate.sessionManager loginParams:session];
    
    [self setHttpRequestHeaders:headers];
    
    __block ALMSession * blockSession = session;
    __weak typeof(self) weakSelf = self;
    __block NSURLSessionDataTask *operation = nil;
    
    operation = [self POST:loginPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            __strong typeof(self) strongSelf = weakSelf;
            
            blockSession = [strongSelf parseResponseHeaders:[httpResponse allHeaderFields] data:responseObject to:blockSession];
            if (onSuccess) {
                onSuccess(operation, blockSession);
            }
        }
        else if (onFail) {
            onFail(operation, nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Could not perform login, error: %@", error);
        if (onFail) {
            onFail(task, error);
        }
    }];
    
    return operation;
}

- (ALMSession *)parseResponseHeaders:(NSDictionary *)headers data:(id)data to:(ALMSession *)session {
    if ([self.requestManagerDelegate respondsToSelector:@selector(parseResponseHeaders:data:to:)]) {
        return [self.requestManagerDelegate parseResponseHeaders:headers data:data to:session];
    }
    else {
        NSDictionary *jsonResponse = @{kAUser : data[kASession][kAUser]};
        
        RLMRealm *realm = session.realm;
        
        [realm beginWriteTransaction];
        
        session.uid = headers[kHttpHeaderFieldUID];
        session.tokenAccessKey = headers[kHttpHeaderFieldAccessToken];
        session.tokenExpiration = [[headers objectForKey:kHttpHeaderFieldExpiry] integerValue];
        session.client = headers[kHttpHeaderFieldClient];
        session.tokenType = headers[kHttpHeaderFieldTokenType];
        
        session.user = [ALMUser createOrUpdateInRealm:realm withJSONDictionary:jsonResponse];
        
        [realm commitWriteTransaction];
        
        return session;
    }
}

- (NSMutableArray *)taskWaitingForAuth {
    if (!_taskWaitingForAuth) {
        _taskWaitingForAuth = [NSMutableArray array];
    }
    return _taskWaitingForAuth;
}

#pragma mark - Errors

+ (NSError*)errorForInvalidClass:(Class)invalidClass {
    return [NSError errorWithDomain:@"Request Manager"
                               code:100
                           userInfo:@{ NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not subclass of RLMResource", invalidClass]}];
}

+ (NSError*)errorForInvalidPath:(NSString*)invalidPath {
    return [NSError errorWithDomain:@"Request Manager"
                               code:101
                           userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ is not a valid URL path.", invalidPath]}];
}
                                  
                                  
@end
