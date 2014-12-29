//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMController.h"

@implementation ALMController

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate {
    self = [super init];
    if (self)
    {
        _controllerDelegate = controllerDelegate;
    }
    return self;
}

- (NSArray *)loadDescriptors {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (RKObjectManager*)objectManager {
    if(_controllerDelegate == nil) {
        return nil;
    }
    return nil;
}

@end
