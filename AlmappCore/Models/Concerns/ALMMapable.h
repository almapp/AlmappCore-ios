//
//  ALMMapable.h
//  AlmappCore
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMPlace;

@protocol ALMMapable <NSObject>

@property ALMPlace *localization;

@end