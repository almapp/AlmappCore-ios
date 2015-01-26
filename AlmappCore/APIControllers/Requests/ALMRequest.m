//
//  ALMRequest.m
//  AlmappCore
//
//  Created by Patricio López on 23-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMRequest.h"
#import "ALMRequestManager.h"

long long const kDefaultRequestID = 1;

NSString *const kHttpHeaderFieldApiKey = @"X-Api-Key";
NSString *const kHttpHeaderFieldAccessToken = @"Access-Token";
NSString *const kHttpHeaderFieldTokenType = @"Token-Type";
NSString *const kHttpHeaderFieldExpiry = @"Expiry";
NSString *const kHttpHeaderFieldClient = @"Client";
NSString *const kHttpHeaderFieldUID = @"Uid";

@interface ALMRequest ()

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

#pragma mark - Constructor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.realmPath = [ALMRequest defaultRealmPath];
    }
    return self;
}


#pragma mark - Realms

+ (NSString *)defaultRealmPath {
    return [RLMRealm defaultRealmPath];
}

- (RLMRealm *)realm {
    return [RLMRealm realmWithPath:_realmPath];
}

- (void)setRealm:(RLMRealm *)realm {
    if (realm) {
        _realmPath = realm.path;
    }
}


#pragma mark - Validations

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
    BOOL sessionRequiredOperation = self.session != nil;
    if (!sessionRequiredOperation) {
        NSLog(@"No auth needed");
        return NO;
    }
    BOOL validToken = self.tokenValidationOperation(self.session);
    if (validToken) {
        NSLog(@"valid token :)");
        return NO;
    }
    else {
        NSLog(@"Expired token, auth needed");
        return YES;
    }
}

- (BOOL)validateRequest {
    if (![self.resourceClass isSubclassOfClass:[ALMResource class]]) {
        return NO;
    }
    return YES;
}


#pragma mark - HTTP Headers

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


#pragma mark - Path methods

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


#pragma mark - Execute operations

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
