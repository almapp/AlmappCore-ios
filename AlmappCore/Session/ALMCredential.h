//
//  ALMCredential.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMCredential : NSObject <NSCoding>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *tokenAccessKey;
@property (assign, nonatomic) NSInteger tokenExpiration;
@property (strong, nonatomic) NSString *client;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *tokenType;

+ (instancetype)credentialForEmail:(NSString *)email;

- (void)save;

@end
