//
//  ALMCore.h
//  AlmappCore
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMCoreDelegate.h"
#import "ALMUtil.h"
#import "ALMControllerDelegate.h"

@interface ALMCore : NSObject <ALMControllerDelegate>

@property (strong, nonatomic) NSString* persistenceStoreName;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL;

+ (instancetype)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString*)baseURLString;

+ (instancetype)sharedInstance;

+ (void)shutDown;

+ (void)setSharedInstance:(ALMCore*)instance;

- (NSArray*)availableUsers;

- (void)setPersistenceStoreNameToDefault;

@end
