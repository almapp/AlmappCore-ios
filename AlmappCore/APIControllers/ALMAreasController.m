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

- (id)commit:(NSDictionary*)data ofClass:(Class)resourceClass inRealm:(RLMRealm*)realm  {
    NSDictionary* localization = [self extractLocalizationAsPlaceDictionaryFrom:data];
    
    ALMArea* result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:data];
    if(localization != nil) {
        ALMPlace* place = [ALMPlace createOrUpdateInRealm:realm withJSONDictionary:localization];
        [result setLocalization:place];
        [place setArea:result];
    }
    return result;
}

- (NSArray*)commitCollection:(NSArray*)data ofClass:(Class)resourceClass inRealm:(RLMRealm *)realm {
    NSMutableArray *collection = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary* area in data) {
        ALMArea* result = [self commit:area ofClass:resourceClass inRealm:realm];
        [collection addObject:result];
    }
    return collection;
}

- (ALMCommitResourceOperation)commitResource {
    return (id)^(RLMRealm *realm, Class resourceClass, NSDictionary *data) {
        
        [realm beginWriteTransaction];
        id result = [self commit:data ofClass:resourceClass inRealm:realm];
        [realm commitWriteTransaction];
        
        return result;
    };
}

- (ALMCommitResourcesOperation)commitResources {
    return  ^(RLMRealm *realm, Class resourceClass, NSArray *data) {
        
        [realm beginWriteTransaction];
        NSArray* collection = [self commitCollection:data ofClass:resourceClass inRealm:realm];
        [realm commitWriteTransaction];
        
        return collection;
    };
}

- (ALMCommitNestedResourcesOperation)commitNestedResources {
    return ^(RLMRealm* realm, Class resourceClass, Class parentClass, long long parentID, NSArray* data) {
        
        ALMResource* parent = [ALMResource objectInRealm:realm ofType:parentClass withID:parentID];
        
        NSString *nestedCollectionName = [resourceClass performSelector:@selector(realmPluralForm)];
        NSString *resourceParentName = [parentClass performSelector:@selector(realmSingleForm)];
        
        // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", nestedCollectionName]);
        SEL parentSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [resourceParentName capitalizedString]]);
        
        [realm beginWriteTransaction];
        
        NSArray* collection = [self commitCollection:data ofClass:resourceClass inRealm:realm];
        
        if ([parent respondsToSelector:collectionSelector]) {
            IMP imp = [parent methodForSelector:collectionSelector];
            RLMArray* (*func)(id, SEL) = (void*)imp;
            RLMArray *parentNestedResourcecollection = func(parent, collectionSelector);
            
            [parentNestedResourcecollection removeAllObjects];
            [parentNestedResourcecollection addObjects:collection];
        }
        
        for (ALMResource *resource in collection) {
            if([resource respondsToSelector:parentSelector]) {
                IMP imp = [resource methodForSelector:parentSelector];
                void (*func)(id, SEL, ALMResource*) = (void*)imp;
                func(resource, parentSelector, parent);
            }
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
