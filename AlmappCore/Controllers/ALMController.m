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
    
    /*
     AFOAuth2Manager *OAuth2Manager =
     [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
     clientID:@"1a747c5d5de3753129d7376c3a84a208b01a1d52dcca1c0463c8ae7d644abb6f"
     secret:@"9fbdb3d5639f916d87661bf23e1688c5b45c8d207deacdcb0b1192e040792672"];
     */
    __weak __typeof(self) weakSelf = self;
    
    [OAuth2Manager authenticateUsingOAuthWithURLString:oauthUrl
                                              username:email
                                              password:password
                                                 scope:scope
                                               success:^(AFOAuthCredential *credential) {
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
                                                       
                                                   }
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error: %@", error);
                                               }];
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
        
        dispatch_async(weakSelf.concurrentQueue, ^{
            [weakSelf GET:request];
        });
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
