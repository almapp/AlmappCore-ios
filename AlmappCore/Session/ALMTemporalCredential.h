//
//  ALMTemporalCredential.h
//  AlmappCore
//
//  Created by Patricio López on 17-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCredential.h"

@interface ALMTemporalCredential : ALMCredential

+ (instancetype)credentialForEmail:(NSString *)email password:(NSString *)password;

@end
