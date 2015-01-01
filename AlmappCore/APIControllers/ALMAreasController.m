//
//  ALMAreasController.m
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMAreasController.h"


@implementation ALMAreasController

- (ALMCommitResourceOperation)commitResource {
    return (id)^(RLMRealm *realm, Class resourceClass, NSDictionary *data) {
        
        // TODO
        
        [realm beginWriteTransaction];
        id result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return result;
    };
}

- (ALMCommitResourcesOperation)commitResources {
    return  ^(RLMRealm *realm, Class resourceClass, NSArray *data) {
        
        // TODO
        
        [realm beginWriteTransaction];
        NSArray* collection = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONArray:) withObject:realm withObject:data];
        [realm commitWriteTransaction];
        
        return collection;
    };
}

@end
