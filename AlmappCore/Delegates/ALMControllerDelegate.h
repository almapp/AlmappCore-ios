//
//  ALMControllerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMCredential;

@protocol ALMControllerDelegate<NSObject>

@optional

- (void)controllerWillRefreshTokenForCredential:(ALMCredential *)credential;
- (void)controllerSuccessfullyLoggedWithCredential:(ALMCredential *)credential;
- (void)controllerFailedLoginWith:(ALMCredential *)credential error:(NSError *)error;

@end