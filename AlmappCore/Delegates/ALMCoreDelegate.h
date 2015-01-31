//
//  ALMCoreDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALMCoreDelegate <NSObject>

@optional

- (void)coreStartPerformingNetworkTask;
- (void)coreStopPerformingNetworkTask;

- (short)coreCurrentAcademicYear;
- (short)coreCurrentAcademicPeriod;

@end