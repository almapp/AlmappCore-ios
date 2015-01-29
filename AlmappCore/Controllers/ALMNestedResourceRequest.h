//
//  ALMNestedResourceRequest.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceRequest.h"

@interface ALMNestedResourceRequest : ALMResourceRequest <ALMRequestDelegate>

@property (strong, nonatomic) ALMResource *parent;
@property (strong, nonatomic) Class parentClass;
@property (strong, nonatomic) NSString *parentCustomPath;
@property (assign, nonatomic) long long parentID;

@property (strong, nonatomic) ALMResourceRequest *parentRequest;

@property (strong, nonatomic) ALMResourceRequest *nestedCollectionRequest;

+ (instancetype)requestNested:(void(^)(ALMNestedResourceRequest *r))builderBlock delegate:(id<ALMRequestDelegate>)delegate;

+ (NSString *)intuitedPathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID;

@end
