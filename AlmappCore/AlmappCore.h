//
//  AlmappCore.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//
//  Following instructions from:
//  Framework with cocoapods: http://blog.sigmapoint.pl/developing-static-library-for-ios-with-cocoapods/
//  Singleton testing: http://twobitlabs.com/2013/01/objective-c-singleton-pattern-unit-testing/
//  RESTKit: http://www.raywenderlich.com/58682/introduction-restkit-tutorial
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ALMCoreDelegate.h"
#import "ALMUtil.h"
#import "ALMControllerDelegate.h"

@interface AlmappCore : NSObject <ALMControllerDelegate>

+ (AlmappCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURL:(NSURL*)baseURL;

+ (AlmappCore*)initInstanceWithDelegate:(id<ALMCoreDelegate>)delegate baseURLString:(NSString*)baseURLString;

+ (AlmappCore*)sharedInstance;

+ (void)shutDown;

+ (void)setSharedInstance:(AlmappCore*)instance;

- (NSArray*)availableUsers;

@end
