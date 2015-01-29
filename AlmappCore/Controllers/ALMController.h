//
//  ALMController.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Realm+JSON/RLMObject+JSON.h>

#import "ALMRequestManagerDelegate.h"
#import "ALMCoreModuleDelegate.h"

#import "ALMResourceRequest.h"

@interface ALMController : AFHTTPSessionManager

#pragma mark - Delegates

@property (weak, nonatomic) id<ALMRequestManagerDelegate> requestManagerDelegate;

- (id)init __attribute__((unavailable));
+ (instancetype)requestManagerWithURL:(NSURL *)url coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;
+ (instancetype)requestManagerWithURL:(NSURL *)url configuration:(NSURLSessionConfiguration *)configuration coreDelegate:(id<ALMCoreModuleDelegate>)coreDelegate;


@end
