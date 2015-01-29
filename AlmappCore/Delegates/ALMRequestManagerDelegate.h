//
//  ALMRequestManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSession, ALMRequestManager, ALMResourceRequest;

@protocol ALMRequestManagerDelegate <NSObject>

@optional

- (ALMSession *)requestManager:(ALMRequestManager *)manager parseResponseHeaders:(NSDictionary *)headers data:(id)data to:(ALMSession *)session;

- (NSDictionary *)requestManager:(ALMRequestManager *)manager httpRequestHeardersWithApiKey:(NSString *)apiKey as:(ALMSession *)session;

- (NSDictionary *)requestManager:(ALMRequestManager *)manager httpResponseHeardersWithApiKey:(NSString *)apiKey as:(ALMSession *)session;

- (BOOL)requestManager:(ALMRequestManager *)manager validate:(ALMResourceRequest *)request;

- (BOOL)request:(ALMResourceRequest *)request isTokenValidFor:(ALMSession *)session;

- (BOOL)request:(ALMResourceRequest *)request shouldForceLogin:(ALMSession *)session;

- (BOOL)requestManager:(ALMRequestManager *)manager willPerformLoginAs:(ALMSession *)session;
- (void)requestManager:(ALMRequestManager *)manager authError:(NSError *)error as:(ALMSession *)session;
- (void)requestManager:(ALMRequestManager *)manager loggedAs:(ALMSession *)session;

@end
