//
//  ALMAreasController.m
//  AlmappCore
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMAreasController.h"

@implementation ALMAreasController


/*
- (AFHTTPRequestOperation *)updatePlacesForArea:(ALMArea *)area parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    NSString* path = [NSString stringWithFormat:@"%@/%ld/places", [self resourcePathFor:area.class], (long)area.resourceID];
    
    ALMArea * __block weakArea = area;
    ALMAreasController * __weak weakSelf = self;
    
    AFHTTPRequestOperation *op = [super resourceCollectionForClass:[ALMPlace class] inPath:path parameters:nil onSuccess:^(NSArray *result) {
        
        RLMRealm* realm = [weakSelf requestRealm];
        [realm beginWriteTransaction];
        [weakArea.places addObjects:result];
        [realm commitWriteTransaction];
 
        onSuccess(weakArea.places);
        
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        onFailure(error);
    }];
    return op;
}
 */

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
