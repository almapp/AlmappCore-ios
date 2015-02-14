//
//  ALMResourceResponse.h
//  AlmappCore
//
//  Created by Patricio López on 13-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALMSession.h"
#import "ALMResponseDelegate.h"

@interface ALMResourceResponse : NSObject

#pragma mark - Constructor

+ (instancetype)response:(void(^)(ALMResourceResponse *r))builderBlock delegate:(id<ALMResponseDelegate>)delegate;


#pragma mark - Delegate

@property (weak, nonatomic) id<ALMResponseDelegate> responseDelegate;

@property (strong, nonatomic) ALMCredential *credential;

@property (strong, nonatomic) ALMResource *resource;
@property (strong, nonatomic) ALMResource *parent;


- (void)publishError:(NSError *)error task:(NSURLSessionDataTask *)task;
- (void)publishSuccess:(id)response task:(NSURLSessionDataTask *)task;
- (id)serialize;
- (ALMResource *)commitData:(id)data;


@property (strong, nonatomic) NSString *realmPath;
- (RLMRealm *)realm;
- (void)setRealm:(RLMRealm *)realm;

@property (strong, nonatomic) NSString *customPath;
@property (copy, readonly) NSString *intuitedPath;
@property (readonly) NSString *path;

@property (assign, nonatomic) BOOL shouldLog;


+ (NSString *)intuitedPathFor:(Class)resourceClass nestedOn:(ALMResource *)parent;

@end
