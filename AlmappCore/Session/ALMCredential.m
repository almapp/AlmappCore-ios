//
//  ALMCredential.m
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>

#import "ALMCredential.h"
#import "ALMCore.h"

@implementation ALMCredential

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeInteger:self.tokenExpiration forKey:@"tokenExpiration"];
    [encoder encodeObject:self.client forKey:@"client"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.tokenType forKey:@"tokenType"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.email = [decoder decodeObjectForKey:@"email"];
        self.tokenExpiration = [decoder decodeIntegerForKey:@"tokenExpiration"];
        self.client = [decoder decodeObjectForKey:@"client"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.tokenType = [decoder decodeObjectForKey:@"tokenType"];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.email = self.tokenAccessKey = self.client = self.uid = self.tokenType = @"";
    }
    return self;
}

- (void)setPassword:(NSString *)password {
    self.keyStore[self.email] = password;
}

- (NSString *)password {
    return self.keyStore[self.email];
}

- (UICKeyChainStore *)keyStore {
    return [ALMCore keyStore];
}

- (void)save {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:self.email];
    [defaults synchronize];
}

+ (instancetype)credentialForEmail:(NSString *)email {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:email];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

@end
