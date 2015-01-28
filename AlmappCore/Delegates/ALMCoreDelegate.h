//
//  ALMCoreDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMSession.h"

@protocol ALMCoreDelegate <NSObject>

- (void)startPerformingNetworkTask;
- (void)stopPerformingNetworkTask;

@optional
- (short)currentAcademicYear;
- (short)currentAcademicPeriod;

@end