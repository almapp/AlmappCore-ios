//
//  ALMNestedResourceRequest.h
//  AlmappCore
//
//  Created by Patricio López on 29-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceRequest.h"
#import "ALMNestedRequestDelegate.h"

@interface ALMNestedResourceRequest : ALMResourceRequest <ALMRequestDelegate>


#pragma mark - Constructor

+ (instancetype)requestNested:(void(^)(ALMNestedResourceRequest *r))builderBlock delegate:(id<ALMNestedRequestDelegate>)delegate;


#pragma mark - Delegate

@property (weak, nonatomic) id<ALMNestedRequestDelegate> nestedRequestDelegate;


#pragma mark - Resource parent

@property (strong, nonatomic) ALMResource *parent;
@property (strong, nonatomic) Class parentClass;
@property (strong, nonatomic) NSString *parentCustomPath;
@property (assign, nonatomic) long long parentID;

@property (strong, nonatomic) NSString *nestedCollectionAlias;
@property (strong, nonatomic) NSString *parentAlias;

@property (strong, nonatomic) ALMResourceRequest *parentRequest;
@property (strong, nonatomic) ALMResourceRequest *nestedCollectionRequest;


#pragma mark - Path

+ (NSString *)intuitedPathFor:(Class)resourceClass inParent:(Class)parentClass parentID:(long long)parentID;

@end
