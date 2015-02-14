//
//  ALMResponseDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLMRealm, RLMResults, ALMResource;
@class ALMController, ALMResourceResponse;

@protocol ALMResponseDelegate <NSObject>

@optional

- (void)response:(ALMResourceResponse *)response error:(NSError *)error task:(NSURLSessionDataTask *)task;
- (void)response:(ALMResourceResponse *)response success:(id)responseData task:(NSURLSessionDataTask *)task;
- (id)response:(ALMResourceResponse *)response customSerialization:(ALMResource *)resouse;


@end