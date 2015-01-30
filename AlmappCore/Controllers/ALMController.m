//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"
#import "ALMSessionManager.h"
#import "ALMResourceConstants.h"

@implementation NSDate (Compare)

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

@end



@interface ALMController ()

@property (weak, nonatomic) id<ALMCoreModuleDelegate> coreModuleDelegate;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end



@implementation ALMController

+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    return [self controllerWithURL:url configuration:nil coreDelegate:coreDelegate];
}

+ (instancetype)controllerWithURL:(NSURL *)url configuration:(NSURLSessionConfiguration *)configuration coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    ALMController *manager = [[self alloc] initWithBaseURL:url sessionConfiguration:configuration];
    manager.coreModuleDelegate = coreDelegate;
    return manager;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    NSAssert(url != nil, @"Must provide a URL");
    
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.concurrentQueue = dispatch_queue_create("com.almappcore.controller.requestQueue",
                                                          DISPATCH_QUEUE_CONCURRENT);
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


#pragma mark - GET

- (id)LOAD:(ALMResourceRequest *)request {
    RLMRealm *realm = request.realm;
    
    if (request.isRequestingACollection) {
        RLMResults *results = (request.resourcesIDs) ?
        [ALMResource objectsOfType:request.resourceClass inRealm:realm withIDs:request.resourcesIDs] :
        [ALMResource allObjectsOfType:request.resourceClass inRealm:realm];
        
        [request sortOrFilterResources:results];
        
        return results;
    }
    else {
        ALMResource *result = [ALMResource objectOfType:request.resourceClass withID:request.resourceID inRealm:realm];
        return result;
    }
}

- (void)FETCHMultiple:(NSArray *)requests {
    for (ALMResourceRequest *request in requests) {
        [self FETCH:request];
    }
}

- (void)FETCH:(ALMResourceRequest *)request {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (!request) {
            dispatch_async(request.dispatchQueue, ^{
                [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
            });
            return;
        }
        
        if (![weakSelf validate:request]) {
            dispatch_async(request.dispatchQueue, ^{
                [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
            });
            return;
        }
        
        dispatch_async(request.dispatchQueue, ^{
            id results = [weakSelf LOAD:request];
            [request publishLoaded:results];
        });
        
        NSDictionary *headers = [weakSelf getHttpRequestHeadersFor:request.credential];
        [ALMHTTPHeaderHelper setHttpRequestHeaders:headers toSerializer:self.requestSerializer];
        
        BOOL needsAuth = [weakSelf shouldPerformLoginTo:request];
        
        if (_isLogingIn && needsAuth) {
            dispatch_sync(weakSelf.concurrentQueue, ^{
                [weakSelf GET:request];
            });
        }
        else if(needsAuth) {
            _isLogingIn = YES;

            dispatch_barrier_async(weakSelf.concurrentQueue, ^{
                NSURLSessionDataTask *loginTask = [weakSelf performLoginTaskWith:request.credential saveInRealm:request.realm onSuccess:^(NSURLSessionDataTask *task, ALMSession *session) {
                    dispatch_async(weakSelf.concurrentQueue, ^{
                        _isLogingIn = NO;
                        __strong __typeof(weakSelf) strongSelf = weakSelf;
                        if (strongSelf) {
                            [strongSelf GET:request];
                        }
                    });
                } onFail:^(NSURLSessionDataTask *task, NSError *error) {
                    dispatch_async(request.dispatchQueue, ^{
                        [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
                    });
                }];
                
                NSLog(@"Login task: %@", loginTask);
            });
        }
        else {
            dispatch_async(weakSelf.concurrentQueue, ^{
                [weakSelf GET:request];
            });
        }
    });
}

- (NSURLSessionDataTask *)GET:(ALMResourceRequest *)request {
    if ([request isKindOfClass:[ALMNestedResourceRequest class]]) {
        [self GET:[(ALMNestedResourceRequest *)request parentRequest]];
        return [self GET:[(ALMNestedResourceRequest *)request nestedCollectionRequest]];
    }
    
    NSURLSessionDataTask *op = [self GET:request.path parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BOOL success = [request commitData:responseObject];
        if (request.shouldLog) {
            NSLog(@"Commit status %d",success);
        }
        
        dispatch_async(request.dispatchQueue, ^{
            id results = [self LOAD:request];
            [request publishFetched:results task:task];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (request.shouldLog) {
            NSLog(@"Error %@", error);
        }
        dispatch_async(request.dispatchQueue, ^{
            [request publishError:error task:task];
        });
    }];
    
    return op;
}

- (NSURLSessionDataTask *)LOGIN:(ALMCredential *)credential onSuccess:(void (^)(NSURLSessionDataTask *, ALMSession *))onSuccess onFail:(void (^)(NSURLSessionDataTask *, NSError *))onFail {
    
    return [self performLoginTaskWith:credential saveInRealm:nil onSuccess:^(NSURLSessionDataTask *task, ALMSession *session) { // TODO: Realm param
        if (onSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                onSuccess(task, nil); // TODO: get session
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

- (NSURLSessionDataTask *)performLoginTaskWith:(ALMCredential *)credential
                                   saveInRealm:(RLMRealm *)realm
                                          onSuccess:(void (^)(NSURLSessionDataTask *task, ALMSession *session))onSuccess
                                             onFail:(void (^)(NSURLSessionDataTask *task, NSError *error))onFail {
    
    NSDictionary *headers = [self getHttpRequestHeadersFor:nil];
    [ALMHTTPHeaderHelper setHttpRequestHeaders:headers toSerializer:self.requestSerializer];
    
    ALMSessionManager *manager = [self.coreModuleDelegate moduleSessionManagerFor:self.class];
    NSString *loginPath = [manager loginPostPath:[self baseURL]];
    NSDictionary *params = [manager loginParams:credential];
    
    [self setHttpRequestHeaders:headers];
    
    __block ALMCredential * blockCredential = credential;
    __weak typeof(self) weakSelf = self;
    __block NSURLSessionDataTask *operation = nil;
    
    operation = [self POST:loginPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            
            ALMSession *session = nil;
            
            if ([weakSelf.requestManagerDelegate respondsToSelector:@selector(requestManager:parseResponseHeaders:data:withCredential:)]) {
                session = [weakSelf.requestManagerDelegate requestManager:nil parseResponseHeaders:[httpResponse allHeaderFields] data:responseObject withCredential:credential];
            }
            else {
                NSDictionary *userJsonResponse = @{kAUser : responseObject[kASession][kAUser]};
                NSDictionary *privateJsonResponse = responseObject[kASession][@"private_data"];
                
                [ALMHTTPHeaderHelper setHeaders:[httpResponse allHeaderFields] toCredential:blockCredential];
                
                [realm beginWriteTransaction];
                
                ALMUser *user = [ALMUser createOrUpdateInRealm:realm withJSONDictionary:userJsonResponse];
                
                session = [[ALMSession alloc] init];
                session.email = blockCredential.email;
                session.lastIP = privateJsonResponse[@"last_sign_in_ip"];
                session.currentIP = privateJsonResponse[@"current_sign_in_ip"];
                session.user = user;
                
                session = [ALMSession createOrUpdateInRealm:realm withObject:session];
                session.credential = blockCredential;
                
                [realm commitWriteTransaction];
            }
            
            if (onSuccess) {
                onSuccess(operation, session);
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


- (NSDictionary *)getHttpRequestHeadersFor:(ALMCredential *)credential {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:httpRequestHeardersWithApiKey:as:)]) {
        NSDictionary *headers = [_requestManagerDelegate requestManager:nil httpRequestHeardersWithApiKey:[self apiKey] as:credential];
        return headers;
    }
    else {
        NSDictionary *headers = [ALMHTTPHeaderHelper createHeaderHashForCredential:credential apiKey:[self apiKey]];
        return headers;
    }
}




#pragma mark - Delegate usage

- (NSString *)apiKey {
    return [self.coreModuleDelegate moduleApiKeyFor:[self class]];
}

- (RLMRealm*)temporalRealm {
    return [self.coreModuleDelegate moduleTemporalRealmFor:[self class]];
}

- (RLMRealm*)defaultRealm {
    return [self.coreModuleDelegate moduleDefaultRealmFor:[self class]];
}

- (RLMRealm *)encryptedRealm {
    return [self.coreModuleDelegate moduleEncryptedRealmFor:[self class]];
}

- (void)setHttpRequestHeaders:(NSDictionary *)headers {
    for (NSString *headerField in headers.allKeys) {
        NSString *httpHeaderValue = headers[headerField];
        [self.requestSerializer setValue:httpHeaderValue forHTTPHeaderField:headerField];
    }
}

- (void)publishWillPerformLoginAs:(ALMSession *)session {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:willPerformLoginAs:)]) {
        [_requestManagerDelegate requestManager:nil willPerformLoginAs:session];
    }
}

- (void)publishSuccessfulLoginAs:(ALMSession *)session {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:loggedAs:)]) {
        [_requestManagerDelegate requestManager:nil loggedAs:session];
    }
}

- (void)publishFailedLoginAs:(ALMCredential *)credentials error:(NSError *)error {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:authError:withCredentials:)]) {
        [_requestManagerDelegate requestManager:nil authError:error withCredentials:credentials];
    }
}

- (BOOL)validate:(ALMResourceRequest *)request {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:validate:)]) {
        return [_requestManagerDelegate requestManager:nil validate:request];
    }
    else {
        return YES;
    }
}

- (BOOL)shouldPerformLoginTo:(ALMResourceRequest *)request {
    if (!request.credential) {
        return NO;
    }
    
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(request:shouldForceLogin:)]) {
        if([_requestManagerDelegate request:request shouldForceLogin:request.credential]) {
            return YES;
        }
    }
    
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(request:isTokenValidFor:)]) {
        BOOL validToken = [_requestManagerDelegate request:request isTokenValidFor:request.credential];
        return validToken;
    }
    else {
        BOOL validToken = [self isTokenValidFor:request.credential];
        return !validToken;
    }
    
    return NO;
}

- (BOOL)isTokenValidFor:(ALMCredential *)credential {
    if (!credential.tokenAccessKey || credential.tokenAccessKey.length == 0) {
        return NO;
    }
    
    NSDate *expiracyDate = [NSDate dateWithTimeIntervalSince1970:credential.tokenExpiration];
    NSDate *now = [NSDate date];
    return [now isEarlierThan:expiracyDate];
}


@end
