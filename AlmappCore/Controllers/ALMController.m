//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

#import "ALMController.h"
#import "ALMSessionManager.h"
#import "ALMResourceConstants.h"
#import "ALMApiKey.h"

static NSString *const kCredentialKey = @"AlmappCore-Controller";
static NSString *const kDefaultOAuthUrl = @"/oauth/token";
static NSString *const kDefaultOAuthScope = @"";



@interface ALMController ()

@property (weak, nonatomic) id<ALMCoreModuleDelegate> coreModuleDelegate;

@property (strong, nonatomic) AFOAuth2Manager *OAuth2Manager;
@property (strong, nonatomic) AFOAuthCredential *OAuthCredential;
@property (strong, nonatomic) PMKPromise *authPromise;

@property (strong, nonatomic) dispatch_queue_t concurrentQueue;

@end



@implementation ALMController

#pragma mark - Constructor

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
        

    }
    return self;
}


#pragma mark - OAuth Credentials

- (AFOAuthCredential *)OAuthCredential {
    if (!_OAuthCredential) {
        _OAuthCredential = [self.class loadCredential];
        [self.requestSerializer setAuthorizationHeaderFieldWithCredential:_OAuthCredential];
    }
    return _OAuthCredential;
}

- (AFOAuth2Manager *)OAuth2Manager {
    if (!_OAuth2Manager) {
        ALMApiKey *apiKey = [self apiKey];
        
        _OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:self.baseURL
                                                             clientID:apiKey.clientID
                                                               secret:apiKey.clientSecret];
    }
    return _OAuth2Manager;
}

+ (AFOAuthCredential *)loadCredential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:kCredentialKey];
}

+ (BOOL)saveCredential:(AFOAuthCredential *)credential {
    return [AFOAuthCredential storeCredential:credential withIdentifier:kCredentialKey];
}


#pragma mark - Auth

- (PMKPromise *)authPromiseWithCredential:(ALMCredential *)credential {
    if (self.OAuthCredential.isExpired) {
        [self publishWillGetTokensWith:credential];
        _authPromise = [self AUTH:credential];
    } else {
        _authPromise = [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller(@YES);
        }];
    }

    return _authPromise;
}

- (PMKPromise *)AUTH:(ALMCredential *)credential {
    return [self AUTH:credential oauthUrl:kDefaultOAuthUrl scope:kDefaultOAuthScope];
}

- (PMKPromise *)AUTH:(ALMCredential *)credential oauthUrl:(NSString *)oauthUrl scope:(NSString *)scope {
    PMKPromise *promise = [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.OAuth2Manager authenticateUsingOAuthWithURLString:oauthUrl username:credential.email password:credential.password scope:scope success:^(AFOAuthCredential *OAuthcredential) {
            
            BOOL didSave = [self.class saveCredential:OAuthcredential];
            if (didSave) {
                NSLog(@"Did Save: %@", OAuthcredential.accessToken);
            }
            else {
                NSLog(@"COULD NOT SAVE TOKEN: %@", OAuthcredential.accessToken);
            }
            
            [self.requestSerializer setAuthorizationHeaderFieldWithCredential:OAuthcredential];
            [self publishSuccessfulLoginWith:credential];
            
            fulfiller(@YES);
            
        } failure:^(NSError *error) {
            [self publishFailedLoginWith:credential error:error];
            rejecter(PMKManifold(credential, error));
        }];
    }];
    
    return promise;
}


#pragma mark - Methods

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
    //__weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if (!request) {
                //dispatch_async(request.dispatchQueue, ^{
                    NSError *error = [ALMError errorWithCode:ALMErrorCodeInvalidRequest];
                    [request publishError:error task:nil];
                    rejecter(PMKManifold(request, error));
                //});
                return;
            }
            
        
            if (![self validateRequest:request]) {
                //dispatch_async(request.dispatchQueue, ^{
                    [request publishError:[ALMError errorWithCode:ALMErrorCodeInvalidRequest] task:nil];
                //});
                return;
            }
            
            //dispatch_async(request.dispatchQueue, ^{
                [self LOAD:request].then(^(id loaded) {
                    [request publishLoaded:loaded];
                });
            //});
            
            //dispatch_async(weakSelf.concurrentQueue, ^{
                [self GET:request].then(^(id fetched, NSURLSessionDataTask *task) {
                    fulfiller(PMKManifold(fetched));
                    
                }).catch(^(ALMResourceRequest *request, NSError *error){
                   rejecter(PMKManifold(request, error));
                });
            //});
        //});
    }];
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
                    [request publishFetched:loaded task:task];
                    fulfiller(PMKManifold(loaded, task));
                });
                
            }).catch(^(NSError *error) {
                if (request.shouldLog) {
                    NSLog(@"Error %@", error);
                }
                [request publishError:error task:nil];
                rejecter(PMKManifold(request, error));
            });
            
        }).catch(^(ALMCredential *credential, NSError *error) {
            if (request.shouldLog) {
                NSLog(@"Error %@", error);
            }
            [request publishError:error task:nil];
            rejecter(PMKManifold(request, error));
        });
        
        //[PMKPromise when:self.authPromise].then(^{
    }];
}

- (PMKPromise *)POST:(ALMResourceRequest *)request {
    return nil;
}

- (PMKPromise *)DELETE:(ALMResourceRequest *)request {
    return nil;
}

- (PMKPromise *)PUT:(ALMResourceRequest *)request {
    return nil;
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

- (void)publishWillGetTokensWith:(ALMCredential *)credential {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerWillRefreshTokenForCredential:)]) {
        [_controllerDelegate controllerWillRefreshTokenForCredential:credential];
    }
}

- (void)publishSuccessfulLoginWith:(ALMCredential *)credential {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerWillRefreshTokenForCredential:)]) {
        [_controllerDelegate controllerSuccessfullyLoggedWithCredential:credential];
    }
}

- (void)publishFailedLoginWith:(ALMCredential *)credential error:(NSError *)error {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerFailedLoginWith:error:)]) {
        [_controllerDelegate controllerFailedLoginWith:credential error:error];
    }
}

- (BOOL)validateRequest:(ALMResourceRequest *)request {
    if (![request.resourceClass isSubclassOfClass:[ALMResource class]]) {
        return NO;
    }
    if (request.resourceID < 0) {
        return NO;
    }
    if (!request.realmPath || request.realmPath.length == 0) {
        return NO;
    }
    return YES;
}

@end
