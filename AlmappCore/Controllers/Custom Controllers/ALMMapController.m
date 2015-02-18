//
//  ALMMapController.m
//  AlmappCore
//
//  Created by Patricio López on 16-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMMapController.h"
#import "ALMCore.h"
#import "ALMCampus.h"
#import "ALMFaculty.h"
#import "ALMBuilding.h"

@implementation ALMMapController

- (PMKPromise *)fetchMaps {
    return [self.controller GETResources:[ALMCampus class] parameters:nil].then( ^(id results, NSURLSessionDataTask *task) {
        return results;
        
    }).then( ^(NSArray *campuses) {
        ALMController *controller = self.controller;
        
        NSMutableArray *promises = [NSMutableArray array];
        
        for (ALMCampus *campus in campuses) {
            
            PMKPromise *promise1 = [controller GETResources:[ALMFaculty class] on:campus parameters:nil];
            PMKPromise *promise2 = [controller GETResources:[ALMBuilding class] on:campus parameters:nil];
            
            [promises addObject:promise1];
            [promises addObject:promise2];
        }
        
        return [PMKPromise when:promises].then(^(NSArray *array) {
            return campuses;
        });
    });
}

@end
