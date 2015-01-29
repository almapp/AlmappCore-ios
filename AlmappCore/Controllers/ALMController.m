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

@end



@implementation ALMController

+ (instancetype)requestManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    return [self requestManagerWithURL:url configuration:nil coreDelegate:coreDelegate];
}

+ (instancetype)requestManagerWithURL:(NSURL *)url configuration:(NSURLSessionConfiguration *)configuration coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate {
    ALMController *manager = [[self alloc] initWithBaseURL:url sessionConfiguration:configuration];
    manager.coreModuleDelegate = coreDelegate;
    return manager;
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    NSAssert(url != nil, @"Must provide a URL");
    
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}


#pragma mark - GET

- (NSURLSessionDataTask *)GET:(ALMResourceRequest *)request {
    if (!request) {
        // TODO: error
        return nil;
    }
    
    if (![self validate:request]) {
        // TODO: error
        return nil;
    }
    
    if ([self shouldPerformLoginTo:request]) {
        
    }
    else {
        
    }
    return nil;
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
