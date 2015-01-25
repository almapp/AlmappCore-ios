//
//  ALMRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequest.h"
#import "ALMRequestManager.h"

long long const kDefaultID = 0;

NSString *const kHttpHeaderFieldApiKey = @"X-Api-Key";
NSString *const kHttpHeaderFieldAccessToken = @"Access-Token";
NSString *const kHttpHeaderFieldTokenType = @"Token-Type";
NSString *const kHttpHeaderFieldExpiry = @"Expiry";
NSString *const kHttpHeaderFieldClient = @"Client";
NSString *const kHttpHeaderFieldUID = @"Uid";

@interface ALMRequest ()

@property (strong, nonatomic) NSString *realmPath;

@end

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

@implementation ALMRequest

+ (RLMRealm *)defaultRealm {
    return [RLMRealm defaultRealm];
}
/*
- (void)setRealm:(RLMRealm *)realm {
    self.realmPath = realm.path;
}

- (RLMRealm *)realm {
    return [RLMRealm realmWithPath:self.realmPath];
}
 */

- (BOOL (^)(ALMSession*))tokenValidationOperation {
    if (!_tokenValidationOperation) {
        _tokenValidationOperation = [self.class defaultTokenValidationOperation];
    }
    return _tokenValidationOperation;
}

+ (BOOL (^)(ALMSession*))defaultTokenValidationOperation {
    return ^(ALMSession *session) {
        if (!session.tokenAccessKey || session.tokenAccessKey.length == 0) {
            return NO;
        }
        
        NSDate *expiracyDate = [NSDate dateWithTimeIntervalSince1970:session.tokenExpiration];
        NSDate *now = [NSDate date];
        return [now isEarlierThan:expiracyDate];
    };
}

- (BOOL)needsAuthentication {
    return (self.session == nil || self.tokenValidationOperation(self.session));
}

- (NSDictionary *(^)(ALMSession *, NSString *))configureHttpRequestHeaders{
    if (!_configureHttpRequestHeaders) {
        _configureHttpRequestHeaders = [self.class defaultHttpHeaders];
    }
    return _configureHttpRequestHeaders;
}

+ (NSDictionary *(^)(ALMSession *, NSString *))defaultHttpHeaders {
    return ^(ALMSession *session, NSString *apiKey) {
        if (session) {
            return @{ @"access_token" : session.tokenAccessKey,
                      @"token_type"   : session.tokenType,
                      @"client"      : session.client,
                      @"uid"         : session.uid,
                      @"expiry"      : [NSString stringWithFormat:@"%ld", (long)session.tokenExpiration],
                      kHttpHeaderFieldApiKey      : apiKey};
        }
        else {
            return @{kHttpHeaderFieldApiKey : apiKey};
        }
    };
}

+ (NSString *)intuitedPathFor:(Class)resourceClass {
    if ([resourceClass instancesRespondToSelector:@selector(apiPluralForm)]) {
        return [resourceClass performSelector:@selector(apiPluralForm)];
    }
    else {
        return nil;
    }
}

- (NSString *)intuitedPath {
    return [self.class intuitedPathFor:self.resourceClass];
}

- (NSString *)path {
    return (_customPath) ? _customPath : self.intuitedPath;
}

- (BOOL)validateRequest {
    if (![self.resourceClass isSubclassOfClass:[ALMResource class]]) {
        return NO;
    }
    return YES;
}

- (id)execCommit:(id)data {
    NSException* myException = [NSException
                                exceptionWithName:@"Subclass must override"
                                reason:@"Method not implemented by subclass"
                                userInfo:nil];
    @throw myException;
}

- (void)execOnLoad {
    NSException* myException = [NSException
                                exceptionWithName:@"Subclass must override"
                                reason:@"Method not implemented by subclass"
                                userInfo:nil];
    @throw myException;
}

- (void)execOnFinishWithTask:(NSURLSessionDataTask *)task {
    NSException* myException = [NSException
                                exceptionWithName:@"Subclass must override"
                                reason:@"Method not implemented by subclass"
                                userInfo:nil];
    @throw myException;
}

- (id)execFetch:(NSURLSessionDataTask *)task fetchedData:(id)result {
    return result;
}

@end
