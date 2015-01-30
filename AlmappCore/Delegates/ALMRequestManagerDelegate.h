//
//  ALMRequestManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSession, ALMRequestManager, ALMResourceRequest, ALMCredential;

@protocol ALMRequestManagerDelegate <NSObject>

@optional

- (ALMSession *)requestManager:(ALMRequestManager *)manager parseResponseHeaders:(NSDictionary *)headers data:(id)data withCredential:(ALMCredential *)credential;

- (NSDictionary *)requestManager:(ALMRequestManager *)manager httpRequestHeardersWithApiKey:(NSString *)apiKey as:(ALMCredential *)credential;

- (NSDictionary *)requestManager:(ALMRequestManager *)manager httpResponseHeardersWithApiKey:(NSString *)apiKey as:(ALMCredential *)credential;

- (BOOL)requestManager:(ALMRequestManager *)manager validate:(ALMResourceRequest *)request;

- (BOOL)request:(ALMResourceRequest *)request isTokenValidFor:(ALMCredential *)credential;

- (BOOL)request:(ALMResourceRequest *)request shouldForceLogin:(ALMCredential *)credential;

- (BOOL)requestManager:(ALMRequestManager *)manager willPerformLoginAs:(ALMSession *)session;
- (void)requestManager:(ALMRequestManager *)manager authError:(NSError *)error withCredentials:(ALMCredential *)credential;
- (void)requestManager:(ALMRequestManager *)manager loggedAs:(ALMSession *)session;

@end
