//
//  ALMGmailListResponse.h
//  AlmappCore
//
//  Created by Patricio López on 01-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMGmailListResponse : NSObject

+ (instancetype)gmailListResponse:(NSString *)pageToken size:(NSUInteger)size;

@property (strong, nonatomic) NSString *nextPageToken;
@property (assign, nonatomic) NSUInteger estimatedSize;

@end
