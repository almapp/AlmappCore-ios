//
//  ALMResourceResponse.m
//  AlmappCore
//
//  Created by Patricio López on 13-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceResponse.h"

@implementation ALMResourceResponse

+ (instancetype)response:(void (^)(ALMResourceResponse *))builderBlock delegate:(id<ALMResponseDelegate>)delegate {
    NSParameterAssert(builderBlock);
    
    ALMResourceResponse *response = [[self alloc] init];
    response.responseDelegate = delegate;
    
    builderBlock(response);
    
    return response;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.realmPath = [self.class defaultRealmPath];
    }
    return self;
}

- (void)setRealm:(RLMRealm *)realm {
    _realmPath = (realm) ? realm.path : nil;
}

- (RLMRealm *)realm {
    return [RLMRealm realmWithPath:_realmPath];
}

+ (NSString *)defaultRealmPath {
    return [RLMRealm defaultRealmPath];
}



+ (NSString *)intuitedPathFor:(Class)resourceClass {
    if ([resourceClass instancesRespondToSelector:@selector(apiPluralForm)]) {
        return [resourceClass performSelector:@selector(apiPluralForm)];
    }
    else {
        return @"";
    }
}

+ (NSString *)intuitedPathFor:(Class)resourceClass nestedOn:(ALMResource *)parent {
    return [NSString stringWithFormat:@"%@/%lld/%@", parent.apiPluralForm, parent.resourceID, [self intuitedPathFor:resourceClass]];
}

- (NSString *)intuitedPath {
    if (self.parent) {
        return [self.class intuitedPathFor:self.resource.class nestedOn:self.parent];
    }
    else {
        return [self.class intuitedPathFor:self.resource.class];
    }
}

- (NSString *)path {
    return (_customPath) ? _customPath : self.intuitedPath;
}

- (void)publishError:(NSError *)error task:(NSURLSessionDataTask *)task {
    if (_responseDelegate && [_responseDelegate respondsToSelector:@selector(response:error:task:)]) {
        [_responseDelegate response:self error:error task:task];
    }
}

- (void)publishSuccess:(id)response task:(NSURLSessionDataTask *)task {
    if (_responseDelegate && [_responseDelegate respondsToSelector:@selector(response:success:task:)]) {
        [_responseDelegate response:self success:response task:task];
    }
}

- (id)serialize {
    if (_responseDelegate && [_responseDelegate respondsToSelector:@selector(response:customSerialization:)]) {
        return [_responseDelegate response:self customSerialization:self.resource];
    }
    else {
        return self.resource.JSONDictionary;
    }
}

- (ALMResource *)commitData:(id)data {
    RLMRealm *realm = self.realm;
    BOOL success = NO;
    
    [realm beginWriteTransaction];
    
    id saved = [self commitSingle:self.resource.class data:data inRealm:realm];
    success = (saved != nil);
    
    [realm commitWriteTransaction];
    
    return saved;
}

- (ALMResource *)commitSingle:(Class)resourceClass data:(NSDictionary *)data inRealm:(RLMRealm *)realm {
    NSDictionary *finalData = data;
    ALMResource *result = nil;
    
    @try {
        result = [resourceClass performSelector:@selector(createOrUpdateInRealm:withJSONDictionary:) withObject:realm withObject:finalData];
    }
    @catch (NSException *exception) {
        NSLog(@"Error creating object %@: ", exception);
    }
    
    return result;
}


@end
