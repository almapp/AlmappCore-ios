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
        if(localization != nil) {
            ALMPlace* place = [ALMPlace createOrUpdateInRealm:realm withJSONDictionary:localization];
            [result setLocalization:place];
            [place setArea:result];
        }
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
            if(localization != nil) {
                ALMPlace* place = [ALMPlace createOrUpdateInRealm:realm withJSONDictionary:localization];
                [result setLocalization:place];
                [place setArea:result];
            }
    
            [collection addObject:result];
        }
        [realm commitWriteTransaction];
        
        return collection;
    };
}

- (NSDictionary*)extractLocalizationAsPlaceDictionaryFrom:(NSDictionary*)singleArea {
    NSDictionary* body = [[singleArea allValues] firstObject]; // We know that it has a root (dictionary with one tuple).
    NSObject* localizationBody = [body objectForKey:@"localization"];
    if(localizationBody == nil ||[localizationBody isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else {
        return @{ @"place" : (NSDictionary*)localizationBody };
    }
}

@end
