//
//  ALMControllerDelegate.h
//  AlmappCore
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALMControllerDelegate <NSObject>

@required
- (NSString*)baseURL;
- (BOOL)inTestingEnvironment;

@end
