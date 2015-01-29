//
//  ALMRequestManagerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMSession, ALMRequestManager;

@protocol ALMRequestManagerDelegate <NSObject>

@optional

- (ALMSession *)requestManager:(ALMRequestManager *)manager parseResponseHeaders:(NSDictionary *)headers data:(id)data to:(ALMSession *)session;

@end
