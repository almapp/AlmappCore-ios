//
//  ALMResourceRequest.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMSession.h"
#import "ALMRequestDelegate.h"

extern BOOL const kRequestForceLogin;

@interface ALMResourceRequest : NSObject

@property (weak, nonatomic) id<ALMRequestDelegate> requestDelegate;

@property (strong, nonatomic) NSString *realmPath;
@property (readonly) RLMRealm *realm;
- (void)setRealm:(RLMRealm *)realm;

@property (weak, nonatomic) ALMSession *session;

@property (strong, nonatomic) NSString *customPath;
@property (copy, readonly) NSString *intuitedPath;
@property (readonly) NSString *path;

@property (assign, nonatomic) long long resourceID;
@property (strong, nonatomic) Class resourceClass;
@property (strong, nonatomic) id parameters;

@property (assign, nonatomic) BOOL shouldLog;
@property (readonly) BOOL isRequestingACollection;

+ (instancetype)request:(void(^)(ALMResourceRequest *r))builderBlock delegate:(id<ALMRequestDelegate>)delegate;

+ (NSString *)intuitedPathFor:(Class)resourceClass;
+ (NSString *)intuitedPathFor:(Class)resourceClass withID:(long long)resourceID;

@end
