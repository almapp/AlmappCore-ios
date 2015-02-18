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
    [encoder encodeObject:self.username forKey:@"username"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.email = [decoder decodeObjectForKey:@"email"];
        self.username = [decoder decodeObjectForKey:@"username"];
    }
    return self;
}

- (instancetype)init {
    return [self initWithEmail:@""];
}

- (instancetype)initWithEmail:(NSString *)email {
    self = [super init];
    if (self) {
        self.email = email;
    }
    return self;
}

- (void)setPassword:(NSString *)password {
    self.keyStore[self.email] = password;
    [self save];
}

- (NSString *)password {
    return self.keyStore[self.email];
}

- (NSString *)username {
    if (!_username) {
        _username = [self.email componentsSeparatedByString:@"@"][0];
    }
    return _username;
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
    if (encodedObject && encodedObject.length > 0) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    else {
        return [[self alloc] initWithEmail:email];
    }
}

@end
