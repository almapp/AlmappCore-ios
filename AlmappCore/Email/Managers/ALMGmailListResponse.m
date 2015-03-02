//
//  ALMGmailListResponse.m
//  AlmappCore
//
//  Created by Patricio López on 01-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMGmailListResponse.h"

@implementation ALMGmailListResponse

+ (instancetype)gmailListResponse:(NSString *)pageToken size:(NSUInteger)size {
    ALMGmailListResponse * response = [[ALMGmailListResponse alloc] init];
    response.nextPageToken = pageToken;
    response.estimatedSize = size;
    return response;
}

@end
