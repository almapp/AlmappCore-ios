//
//  ALMCredential.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMCredential : NSObject <NSCoding>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

+ (instancetype)credentialForEmail:(NSString *)email;

- (instancetype)initWithEmail:(NSString *)email;

- (void)save;

@end
