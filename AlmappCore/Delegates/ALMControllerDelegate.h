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

- (void)controllerWillRefreshTokenWithCredential:(ALMCredential *)credential;
- (void)controllerDidRefreshTokenWithCredential:(ALMCredential *)credential;
- (void)controllerFailedLoginWith:(ALMCredential *)credential error:(NSError *)error;

@end