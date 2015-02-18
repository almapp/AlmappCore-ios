//
//  ALMTemporalCredential.m
//  AlmappCore
//
//  Created by Patricio López on 17-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMTemporalCredential.h"

@interface ALMTemporalCredential ()

@property (strong, nonatomic) NSString *temporalPassword;

@end

@implementation ALMTemporalCredential

+ (instancetype)credentialForEmail:(NSString *)email password:(NSString *)password {
    ALMTemporalCredential *credential = [[self alloc] initWithEmail:email];
    credential.temporalPassword = password;
    return credential;
}

- (NSString *)password {
    return _temporalPassword;
}

- (void)setPassword:(NSString *)password {
    _temporalPassword = password;
}

- (void)save {
    ALMCredential *credential = [ALMCredential credentialForEmail:self.email];
    credential.password = self.temporalPassword;
}

@end
