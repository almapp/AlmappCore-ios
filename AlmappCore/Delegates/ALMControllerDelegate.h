//
//  ALMControllerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>

#import "ALMSession.h"

@protocol ALMControllerDelegate <NSObject>

@required

- (RLMRealm *)realmNamed:(NSString *)name;
- (RLMRealm *)defaultRealm;
- (RLMRealm *)temporalRealm;

@end
