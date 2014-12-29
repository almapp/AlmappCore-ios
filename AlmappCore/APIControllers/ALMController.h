//
//  ALMController.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ALMControllerDelegate.h"

@interface ALMController : NSObject

@property (weak, nonatomic) id<ALMControllerDelegate> controllerDelegate;

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate;

/*
 Must override in subclases
 */
- (NSArray*)loadDescriptors;

@end
