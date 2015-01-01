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
        
        NSDictionary* localization = [self extractLocalizationAsPlaceDictionaryFrom:data];
        
        [realm beginWriteTransaction];
        ALMArea* result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
        ALMPlace* place = [ALMPlace createOrUpdateInRealm:realm withJSONDictionary:localization];
        [result setLocalization:place];
        [realm commitWriteTransaction];
        
        return result;
    };
}

- (ALMCommitResourcesOperation)commitResources {
    return  ^(RLMRealm *realm, Class resourceClass, NSArray *data) {
        
        NSMutableArray *collection = [NSMutableArray arrayWithCapacity:data.count];
        
        [realm beginWriteTransaction];
        
        for (NSDictionary* area in data) {
            NSDictionary* localization = [self extractLocalizationAsPlaceDictionaryFrom:area];
            ALMArea* result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:area];
            ALMPlace* place = [ALMPlace createOrUpdateInRealm:realm withJSONDictionary:localization];
            [result setLocalization:place];
            
            [collection addObject:result];
        }
        [realm commitWriteTransaction];
        
        return collection;
    };
}

- (NSDictionary*)extractLocalizationAsPlaceDictionaryFrom:(NSDictionary*)singleArea {
    NSDictionary* body = [[singleArea allValues] firstObject]; // We know that it has a root (dictionary with one tuple).
    NSDictionary* localizationBody = [body objectForKey:@"localization"];
    return @{ @"place" : localizationBody };
}

@end
