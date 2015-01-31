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
#import "ALMApiKey.h"

#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

static NSString *const kCredentialKey = @"AlmappCore-Controller";
static NSString *const kDefaultOAuthUrl = @"/oauth/token";
static NSString *const kDefaultOAuthScope = @"";

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
@property (strong, nonatomic) AFOAuth2Manager *OAuth2Manager;
@property (strong, nonatomic) dispatch_queue_t concurrentQueue;
@property (strong, nonatomic) PMKPromise *authPromise;

@end



@implementation ALMController

+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    return [self controllerWithURL:url coreDelegate:coreDelegate configuration:nil];
}

+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate configuration:(NSURLSessionConfiguration *)configuration{
    ALMController *manager = [[self alloc] initWithBaseURL:url coreDelegate:coreDelegate sessionConfiguration:configuration];
    return manager;
}

- (id)initWithBaseURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    NSAssert(url != nil, @"Must provide a URL");
    
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.coreModuleDelegate = coreDelegate;
        self.concurrentQueue = dispatch_queue_create("com.almappcore.controller.requestQueue",
                                                          DISPATCH_QUEUE_CONCURRENT);
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        ALMApiKey *apiKey = [self apiKey];
        
        self.OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:self.baseURL
                                                                         clientID:apiKey.clientID
                                                                           secret:apiKey.clientSecret];
    }
    return self;
}



- (AFOAuthCredential *)loadCredential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialKey];
}

- (BOOL)saveCredential:(AFOAuthCredential *)credential {
    return [AFOAuthCredential storeCredential:credential withIdentifier:kCredentialKey];
}

- (void)setupWithEmail:(NSString *)email password:(NSString *)password {
    [self setupWithEmail:email password:password oauthUrl:kDefaultOAuthUrl scope:kDefaultOAuthScope];
}

- (void)setupWithEmail:(NSString *)email password:(NSString *)password oauthUrl:(NSString *)oauthUrl scope:(NSString *)scope {
    ALMApiKey *apiKey = [self apiKey];
    
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:self.baseURL
                                                                     clientID:apiKey.clientID
                                                                       secret:apiKey.clientSecret];
    
    __weak __typeof(self) weakSelf = self;
    
    [OAuth2Manager authenticateUsingOAuthWithURLString:oauthUrl username:email password:password scope:scope success:^(AFOAuthCredential *credential) {
        NSLog(@"Token: %@", credential.accessToken);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            BOOL didSave = [strongSelf saveCredential:credential];
            if (didSave) {
                NSLog(@"Did Save: %@", credential.accessToken);
            }
            else {
                NSLog(@"COULD NOT SAVE TOKEN: %@", credential.accessToken);
            }
            
            [strongSelf.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
            
            //[strongSelf.]
            
        }
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (PMKPromise *)AUTH:(ALMCredential *)credential {
    return [self AUTH:credential oauthUrl:kDefaultOAuthUrl scope:kDefaultOAuthScope];
}

- (PMKPromise *)AUTH:(ALMCredential *)credential oauthUrl:(NSString *)oauthUrl scope:(NSString *)scope {
    PMKPromise *promise = [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.OAuth2Manager authenticateUsingOAuthWithURLString:oauthUrl username:credential.email password:credential.password scope:scope success:^(AFOAuthCredential *OAuthcredential) {
            
            BOOL didSave = [self saveCredential:OAuthcredential];
            if (didSave) {
                NSLog(@"Did Save: %@", OAuthcredential.accessToken);
            }
            else {
                NSLog(@"COULD NOT SAVE TOKEN: %@", OAuthcredential.accessToken);
            }
            
            [self.requestSerializer setAuthorizationHeaderFieldWithCredential:OAuthcredential];
            
            fulfiller(@YES);
            
        } failure:^(NSError *error) {
            rejecter(PMKManifold(credential, error));
        }];
    }];
    self.authPromise = promise;
    
    return promise;
}

- (PMKPromise *)authPromiseWithCredential:(ALMCredential *)credential {
    BOOL tokenIsExpiredOrMissing = YES;
    if (tokenIsExpiredOrMissing) {
        _authPromise = [self AUTH:credential];
    }
    return _authPromise;
}

- (PMKPromise *)GET:(ALMResourceRequest *)request {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self authPromiseWithCredential:request.credential].then(^{
            [self GET:request.path parameters:request.parameters].then(^(id responseObject, NSURLSessionDataTask *task){
                BOOL success = [request commitData:responseObject];
                if (request.shouldLog) {
                    NSLog(@"Commit status %d",success);
                }
                
                [self LOAD:request].then(^(id loaded) {
                    fulfiller(PMKManifold(loaded, task));
                });
                
            }).catch(^(NSError *error) {
                if (request.shouldLog) {
                    NSLog(@"Error %@", error);
                }
                rejecter(PMKManifold(request, error));
            });

        }).catch(^(ALMCredential *credential, NSError *error) {
            if (request.shouldLog) {
                NSLog(@"Error %@", error);
            }
            rejecter(PMKManifold(request, error));
        });
        
        //[PMKPromise when:self.authPromise].then(^{
    }];
}

- (PMKPromise *)LOAD:(ALMResourceRequest *)request {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        RLMRealm *realm = request.realm;
        
        if (request.isRequestingACollection) {
            RLMResults *results = (request.resourcesIDs) ?
            [ALMResource objectsOfType:request.resourceClass inRealm:realm withIDs:request.resourcesIDs] :
            [ALMResource allObjectsOfType:request.resourceClass inRealm:realm];
            
            [request sortOrFilterResources:results];
            
            fulfiller(results);
        }
        else {
            ALMResource *result = [ALMResource objectOfType:request.resourceClass withID:request.resourceID inRealm:realm];
            fulfiller(result);
        }
    }];
}

- (PMKPromise *)FETCH:(ALMResourceRequest *)request {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
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
                [weakSelf LOAD:request].then(^(id loaded) {
                    [request publishLoaded:loaded];
                });
            });
            
            dispatch_async(weakSelf.concurrentQueue, ^{
                [weakSelf GET:request].then(^(id fetched, NSURLSessionDataTask *task) {
                    [request publishFetched:fetched task:task];
                });
            });
        });
    }];
}


#pragma mark - Delegate usage

- (ALMApiKey *)apiKey {
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
    /*if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:willPerformLoginAs:)]) {
        [_requestManagerDelegate requestManager:nil willPerformLoginAs:session];
    }*/
}

- (void)publishSuccessfulLoginAs:(ALMSession *)session {
    /*if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:loggedAs:)]) {
        [_requestManagerDelegate requestManager:nil loggedAs:session];
    }*/
}

- (void)publishFailedLoginAs:(ALMCredential *)credentials error:(NSError *)error {
    /*if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:authError:withCredentials:)]) {
        [_requestManagerDelegate requestManager:nil authError:error withCredentials:credentials];
    }*/
}

- (BOOL)validate:(ALMResourceRequest *)request {
    /*if (_requestManagerDelegate && [_requestManagerDelegate respondsToSelector:@selector(requestManager:validate:)]) {
        return [_requestManagerDelegate requestManager:nil validate:request];
    }
    else {
        return YES;
    }
     */
    return YES;

}


@end
