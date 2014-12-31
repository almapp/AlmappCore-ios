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

@protocol ALMControllerDelegate <NSObject>

@required
- (NSString*)baseURL;
- (AFHTTPRequestOperationManager*)requestManager;
- (RLMRealm*)requestRealm;
- (RLMRealm*)requestTemporalRealm;

@end
