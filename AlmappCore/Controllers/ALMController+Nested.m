//
//  ALMController+Nested.m
//  AlmappCore
//
//  Created by Patricio López on 31-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMController+Nested.h"

@implementation ALMController (Nested)

- (PMKPromise *)LOAD:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest {
    NSString *nestedCollectionName = [request.resourceClass performSelector:@selector(realmPluralForm)];
    return [self LOAD:request withParent:parentRequest as:nestedCollectionName];
}

- (PMKPromise *)LOAD:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self LOAD:parentRequest].then(^(ALMResource *parent) {
            SEL collectionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@", collectionName]);
            
            if ([self respondsToSelector:collectionSelector]) {
                IMP imp = [self methodForSelector:collectionSelector];
                RLMArray* (*func)(id, SEL) = (void*)imp;
                RLMArray *parentNestedResourcecollection = func(self, collectionSelector);
                fulfiller(parentNestedResourcecollection);
            } else {
                rejecter(nil);
            }
        });
    }];
}

- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest {
    return [self FETCH:request withParent:parentRequest as:nil];
}

- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName {
    return [self FETCH:request withParent:parentRequest as:collectionName belongsToAs:nil];
}

- (PMKPromise *)FETCH:(ALMResourceRequest *)request withParent:(ALMResourceRequest *)parentRequest as:(NSString *)collectionName belongsToAs:(NSString *)belongsToAlias {
    
    if (!request.customPath) {
        request.customPath = [NSString stringWithFormat:@"%@/%@", parentRequest.path, request.path];
    }
    
    NSString *resourceParentName = (belongsToAlias) ? belongsToAlias : [self.class performSelector:@selector(realmSingleForm)];
    NSString *nestedCollectionName = (collectionName) ? collectionName : [request.resourceClass performSelector:@selector(realmPluralForm)];
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        PMKPromise *parentPromise = [self FETCH:parentRequest].catch(^(NSError *error) {
            rejecter(PMKManifold(request, error));
        });
        
        PMKPromise *nestedPromise = [self FETCH:request].catch(^(NSError *error) {
            rejecter(PMKManifold(request, error));
        });
        
        
        [PMKPromise when:@[parentPromise, nestedPromise]].then(^(NSArray *results){
            ALMResource *parent = results[0];
            RLMResults *collection = results[1];
            [parent hasMany:collection as:nestedCollectionName belongsToAs:resourceParentName];
            
            fulfiller(PMKManifold(parent, collection));
        });
    }];
}

@end