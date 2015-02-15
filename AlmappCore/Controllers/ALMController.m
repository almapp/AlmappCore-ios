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

NSString *const kControllerSearchParams = @"q";

static NSString *const kCredentialKey = @"AlmappCore";
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

+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate credential:(ALMCredential *)credential {
    return [self controllerWithURL:url coreDelegate:coreDelegate configuration:nil credential:credential];
}

+ (instancetype)controllerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate configuration:(NSURLSessionConfiguration *)configuration credential:(ALMCredential *)credential {
    return [[self alloc] initWithBaseURL:url coreDelegate:coreDelegate sessionConfiguration:configuration credential:credential];
}

- (id)initWithBaseURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate sessionConfiguration:(NSURLSessionConfiguration *)configuration credential:(ALMCredential *)credential {
    NSAssert(url != nil, @"Must provide a URL");
    
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.coreModuleDelegate = coreDelegate;
        self.concurrentQueue = dispatch_queue_create("com.almappcore.controller.requestQueue", DISPATCH_QUEUE_CONCURRENT);
        self.credential = credential;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


#pragma mark - OAuth Credentials

- (AFOAuthCredential *)OAuthCredential {
    if (!_OAuthCredential) {
        _OAuthCredential = [self loadCredential];
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

- (AFOAuthCredential *)loadCredential {
    return [AFOAuthCredential retrieveCredentialWithIdentifier:self.oauthCredentialIdentifier];
}

- (BOOL)saveCredential:(AFOAuthCredential *)credential {
    return [AFOAuthCredential storeCredential:credential withIdentifier:self.oauthCredentialIdentifier];
}

- (BOOL)deleteCredential {
    return [AFOAuthCredential deleteCredentialWithIdentifier:self.oauthCredentialIdentifier];
}

- (NSString *)oauthCredentialIdentifier {
    if (self.credential) {
        return self.credential.email;
    }
    else {
        return @"AlmappCore";
    }
}


#pragma mark - Auth

- (NSString *)OAuthPath {
    if (!_OAuthPath) {
        _OAuthPath = [NSString stringWithFormat:@"/%@/oauth2/token", [self organizationSlug]];
    }
    return _OAuthPath;
}

- (NSString *)OAuthScope {
    if (!_OAuthScope) {
        _OAuthScope = kDefaultOAuthScope;
    }
    return _OAuthScope;
}

- (PMKPromise *)afterAuth {
    if (_authPromise.pending) {
        return _authPromise;
    }
    BOOL present = self.OAuthCredential != nil;
    BOOL expired = present && self.OAuthCredential.isExpired;
    if (present && !expired) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
            fulfiller(self.OAuthCredential.accessToken);
        }];
    }
    else  {
        [self publishWillGetTokensWith:self.credential];
        _authPromise = [self AUTH];
        return _authPromise;
    }
}

- (PMKPromise *)AUTH {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        __weak __typeof(self) weakSelf = self;
        
        void(^success)(AFOAuthCredential *OAuthcredential) = ^(AFOAuthCredential *OAuthcredential) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                BOOL didSave = [strongSelf saveCredential:OAuthcredential];
                if (!didSave) {
                    NSLog(@"COULD NOT SAVE TOKEN: %@", OAuthcredential.accessToken);
                }
                
                [strongSelf setOAuthCredential:OAuthcredential];
                [strongSelf.requestSerializer setAuthorizationHeaderFieldWithCredential:OAuthcredential];
                [strongSelf publishDidRefreshTokenWith:strongSelf.credential];
            }
            
            fulfiller(OAuthcredential.accessToken);
        };
        
        void(^fail)(NSError *error) = ^(NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf onAuthFailure:error];
            }
            
            rejecter(error);
        };
        
        if (self.credential) {
            [self.OAuth2Manager authenticateUsingOAuthWithURLString:self.OAuthPath username:self.credential.email password:self.credential.password scope:self.OAuthScope success:success failure:fail];
        }
        
        else {
            [self.OAuth2Manager authenticateUsingOAuthWithURLString:self.OAuthPath parameters:@{@"grant_type" : @"client_credentials"} success:success failure:fail];
        }
    }];
}

- (void)onAuthFailure:(NSError *)error {
    [self setOAuthCredential:nil];
    
    BOOL didDelete = [self deleteCredential];
    if (!didDelete) {
        NSLog(@"COULD NOT DELETE INVALID TOKEN");
    }
    
    [self publishFailedLoginWith:self.credential error:error];
}


#pragma mark - SEARCH

- (PMKPromise *)SEARCH:(NSString *)query ofType:(Class)resourceClass on:(ALMResource *)parent {
    NSString *path = [resourceClass performSelector:@selector(apiPluralForm)];
    path = [NSString stringWithFormat:@"%@/%lld/%@/search", parent.apiPluralForm, parent.resourceID, path];
    return [self SEARCH:query path:path];
}

- (PMKPromise *)SEARCH:(NSString *)query ofType:(Class)resourceClass {
    NSString *path = [resourceClass performSelector:@selector(apiPluralForm)];
    path = [NSString stringWithFormat:@"%@/search", path];
    return [self SEARCH:query path:path];
}

- (PMKPromise *)SEARCH:(NSString *)query path:(NSString *)path {
    id params = @{kControllerSearchParams : query};
    return [self GET:path parameters:params];
}


#pragma mark - GET

- (PMKPromise *)GETResource:(ALMResource *)resource parameters:(id)parameters {
    //return [self GETResource:resource.class id:resource.resourceID parameters:parameters];
    
    NSString *path = [resource performSelector:@selector(apiPluralForm)];
    path = [NSString stringWithFormat:@"%@/%lld", path, resource.resourceID];
    return [self GET:path parameters:parameters].then(^(id response, NSURLSessionDataTask *task) {
        if (self.saveToRealm) {
            id saved = [ALMController commit:resource.class data:response inRealm:self.realm];
            return PMKManifold(saved, task);
        }
        else {
            return PMKManifold(response, task);
        }
    });
}

- (PMKPromise *)GETResource:(Class)resourceClass id:(long long)resourceId parameters:(id)parameters {
    NSString *path = [resourceClass performSelector:@selector(apiPluralForm)];
    path = [NSString stringWithFormat:@"%@/%lld", path, resourceId];
    return [self GET:path parameters:parameters].then(^(id response, NSURLSessionDataTask *task) {
        if (self.saveToRealm) {
            ALMResource *saved = [ALMController commit:resourceClass data:response inRealm:self.realm];
            return PMKManifold(saved, task);
        }
        else {
            return PMKManifold(response, task);
        }
    });
}

- (PMKPromise *)GETResources:(Class)resourceClass parameters:(id)parameters {
    NSString *path = [resourceClass performSelector:@selector(apiPluralForm)];
    return [self GET:path parameters:parameters].then(^(id response, NSURLSessionDataTask *task) {
        if (self.saveToRealm) {
            id saved = [ALMController commit:resourceClass datas:response inRealm:self.realm];
            return PMKManifold(saved, task);
        }
        else {
            return PMKManifold(response, task);
        }
    });
}

- (PMKPromise *)GETResources:(Class)resourceClass on:(ALMResource *)parent parameters:(id)parameters {
    NSString *path = [resourceClass performSelector:@selector(apiPluralForm)];
    path = [NSString stringWithFormat:@"%@/%lld/%@", parent.apiPluralForm, parent.resourceID, path];
    return [self GETResources:resourceClass path:path parameters:parameters].then(^(id response, NSURLSessionDataTask *task) {
        BOOL isCollection = [response isKindOfClass:[NSArray class]];
        BOOL isResource = isCollection && [((NSArray *)response).firstObject isKindOfClass:[ALMResource class]];
        if (isResource) {
            [parent hasMany:response];
        }
        return PMKManifold(response, task);
    });
}

- (PMKPromise *)GETResources:(Class)resourceClass path:(NSString *)path parameters:(id)parameters {
    return [self GET:path parameters:parameters].then(^(id response, NSURLSessionDataTask *task) {
        if (self.saveToRealm) {
            id saved = [ALMController commit:resourceClass datas:response inRealm:self.realm];
            return PMKManifold(saved, task);
        }
        else {
            return PMKManifold(response, task);
        }
    });
}

- (PMKPromise *)GET:(NSString *)urlString parameters:(id)parameters {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self afterAuth].then( ^(NSString *token) {
            [super GET:urlString parameters:parameters].then(^(id responseObject, NSURLSessionDataTask *task) {
                fulfiller(PMKManifold(responseObject, task));
                
            }).catch(^(NSError *error) {
                if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
                    [self onAuthFailure:error];
                }
                rejecter(error);
            });
        }).catch(^(NSError *error) {
            rejecter(error);
        });
    }];
}


#pragma mark - POST

- (PMKPromise *)POSTResource:(ALMResource *)resource {
    NSString *path = resource.apiPluralForm;
    return [self POSTResource:resource path:path parameters:nil];
}

- (PMKPromise *)POSTResource:(ALMResource *)resource path:(NSString *)path parameters:(id)parameters {
    NSDictionary *data = [resource.JSONDictionary merge:parameters];
    return [self POST:path parameters:data].then(^(id response, NSURLSessionDataTask *task) {
        if (self.saveToRealm) {
            id saved = [ALMController commit:resource.class data:response inRealm:self.realm];
            
            return PMKManifold(saved, task);
        }
        else {
            return PMKManifold(response, task);
        }
    });

}

- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self afterAuth].then( ^(NSString *token) {
            [super POST:urlString parameters:parameters].then(^(id responseObject, NSURLSessionDataTask *task) {
                fulfiller(PMKManifold(responseObject, task));
                
            }).catch(^(NSError *error) {
                if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
                    [self onAuthFailure:error];
                }
                rejecter(error);
            });
        }).catch(^(NSError *error) {
            rejecter(error);
        });
    }];
}

+ (NSArray *)commit:(Class)resourceClass datas:(NSArray *)datas inRealm:(RLMRealm *)realm {
    [realm beginWriteTransaction];
    
    NSArray *result = nil;
    
    @try {
        result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:datas];
    }
    @catch (NSException *exception) {
        NSLog(@"Error creating objects %@: ", exception);
    }
    
    [realm commitWriteTransaction];
    
    return result;
}

+ (ALMResource *)commit:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    [realm beginWriteTransaction];
    
    ALMResource *result = nil;
    
    @try {
        result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
    }
    @catch (NSException *exception) {
        NSLog(@"Error creating object %@: ", exception);
    }
    
    [realm commitWriteTransaction];
    
    return result;
}



#pragma mark - Delegate usage

- (ALMApiKey *)apiKey {
    return [self.coreModuleDelegate moduleApiKeyFor:[self class]];
}

- (NSString *)organizationSlug {
    return [self.coreModuleDelegate organizationSlugFor:[self class]];
}

- (BOOL)saveToRealm {
    return (_saveToRealm && self.realm);
}

- (void)setHttpRequestHeaders:(NSDictionary *)headers {
    for (NSString *headerField in headers.allKeys) {
        NSString *httpHeaderValue = headers[headerField];
        [self.requestSerializer setValue:httpHeaderValue forHTTPHeaderField:headerField];
    }
}

- (void)publishWillGetTokensWith:(ALMCredential *)credential {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerWillRefreshTokenWithCredential:)]) {
        [_controllerDelegate controllerWillRefreshTokenWithCredential:credential];
    }
}

- (void)publishDidRefreshTokenWith:(ALMCredential *)credential {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerDidRefreshTokenWithCredential:)]) {
        [_controllerDelegate controllerDidRefreshTokenWithCredential:credential];
    }
}

- (void)publishFailedLoginWith:(ALMCredential *)credential error:(NSError *)error {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(controllerFailedLoginWith:error:)]) {
        [_controllerDelegate controllerFailedLoginWith:credential error:error];
    }
}


@end
