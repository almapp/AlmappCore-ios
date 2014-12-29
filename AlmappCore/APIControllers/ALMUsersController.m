//
//  ALMUsersController.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMUsersController.h"

@implementation ALMUsersController

- (void)asd{
    ALMUser *user = [[ALMUser alloc] init];
}

- (NSArray *)loadDescriptors {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ALMUser class]];
    
    // JSON : Model
    [mapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                  @"email": @"email",
                                                  @"username": @"username"
                                                  //@"publication_date": @"publicationDate"
                                                  }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"users"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return @[responseDescriptor];
}

@end
