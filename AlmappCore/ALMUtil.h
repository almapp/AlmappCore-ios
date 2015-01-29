//
//  ALMUtil.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMUtil : NSObject

+ (BOOL)validateStringURL:(NSString*)urlString;

+ (NSString *)writeablePathForFile:(NSString*)fileName;

@end
