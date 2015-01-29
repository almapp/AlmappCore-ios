//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController.h"

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
    __block BOOL isLogingInBlock = _isLogingIn;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (!request) {
            [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
            return;
        }
        
        if (![self validate:request]) {
            [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
            return;
        }
        
        dispatch_async(request.dispatchQueue, ^{
            id results = [self LOAD:request];
            [request publishLoaded:results];
        });
        
        NSDictionary *headers = [self getHttpRequestHeadersFor:request.session];
        [ALMHTTPHeaderHelper setHttpRequestHeaders:headers toSerializer:self.requestSerializer];
        
        BOOL needsAuth = [self shouldPerformLoginTo:request];
        
        if (isLogingInBlock && needsAuth) {
            dispatch_sync(self.concurrentQueue, ^{
                [self GET:request];
            });
        }
        else if(needsAuth) {
            isLogingInBlock = YES;
            dispatch_barrier_async(self.concurrentQueue, ^{
                
                dispatch_async(self.concurrentQueue, ^{
                    [self GET:request];
                });
            });
        }
        else {
            dispatch_async(self.concurrentQueue, ^{
                [self GET:request];
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




- (NSDictionary *)getHttpRequestHeadersFor:(ALMSession *)session {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:httpRequestHeardersWithApiKey:as:)]) {
        NSDictionary *headers = [_requestManagerDelegate requestManager:nil httpRequestHeardersWithApiKey:[self apiKey] as:session];
        return headers;
    }
    else {
        NSDictionary *headers = [ALMHTTPHeaderHelper createHeaderHashForSession:session apiKey:[self apiKey]];
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

- (void)publishFailedLoginAs:(ALMSession *)session error:(NSError *)error {
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:authError:as:)]) {
        [_requestManagerDelegate requestManager:nil authError:error as:session];
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
    if (!request.session) {
        return NO;
    }
    
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(request:shouldForceLogin:)]) {
        if([_requestManagerDelegate request:request shouldForceLogin:request.session]) {
            return YES;
        }
    }
    
    if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(request:isTokenValidFor:)]) {
        BOOL validToken = [_requestManagerDelegate request:request isTokenValidFor:request.session];
        return validToken;
    }
    else {
        BOOL validToken = [self isTokenValidFor:request.session];
        return validToken;
    }
    
    return NO;
}

- (BOOL)isTokenValidFor:(ALMSession *)session {
    if (!session.tokenAccessKey || session.tokenAccessKey.length == 0) {
        return NO;
    }
    
    NSDate *expiracyDate = [NSDate dateWithTimeIntervalSince1970:session.tokenExpiration];
    NSDate *now = [NSDate date];
    return [now isEarlierThan:expiracyDate];
}


@end
