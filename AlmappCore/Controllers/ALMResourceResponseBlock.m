//
//  ALMResourceResponseBlock.m
//  AlmappCore
//
//  Created by Patricio López on 14-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMResourceResponseBlock.h"

@implementation ALMResourceResponseBlock

+ (instancetype)response:(void (^)(ALMResourceResponseBlock *))builderBlock {
    NSParameterAssert(builderBlock);
    
    ALMResourceResponseBlock *response = [[self alloc] init];
    response.responseDelegate = response;
    
    builderBlock(response);
    
    return response;
}

+ (instancetype)response:(void (^)(ALMResourceResponseBlock *))builderBlock onSuccess:(void (^)(id, NSURLSessionDataTask *))onSuccess onError:(void (^)(NSError *, NSURLSessionDataTask *))onError {
    
    ALMResourceResponseBlock *response = [self response:builderBlock];
    response.onSuccess = onSuccess;
    response.onError = onError;
    return response;
}

- (void)response:(ALMResourceResponse *)response error:(NSError *)error task:(NSURLSessionDataTask *)task {
    if (_onError) {
        _onError(error, task);
    }
}

- (void)response:(ALMResourceResponse *)response success:(id)responseData task:(NSURLSessionDataTask *)task {
    if (_onSuccess) {
        _onSuccess(responseData, task);
    }
}

- (id)serialize {
    if (_customSerialization) {
        return _customSerialization;
    }
    else {
        return self.resource.JSONDictionary;
    }
}

@end
