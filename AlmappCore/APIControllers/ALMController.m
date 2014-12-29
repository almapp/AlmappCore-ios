//
//  ALMController.m
//  AlmappCore
//
//  Created by Patricio López on 28-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "ALMController.h"

@interface ALMController ()

- (AFHTTPRequestOperationManager*)requestManager;
- (RLMRealm*)requestRealm;

@end

@implementation ALMController

- (id)init {
    self = [super init];
    if (self)
    {
        _controllerDelegate = [AlmappCore sharedInstance];
    }
    return self;
}

- (id)initWithDelegate:(id<ALMControllerDelegate>)controllerDelegate {
    self = [super init];
    if (self)
    {
        _controllerDelegate = controllerDelegate;
    }
    return self;
}

- (AFHTTPRequestOperationManager*)requestManager {
    return [AFHTTPRequestOperationManager manager];
}

-(RLMRealm *)requestRealm {
    if([_controllerDelegate inTestingEnvironment]) {
        return [RLMRealm inMemoryRealmWithIdentifier:(@"TestingRealm")];
    } else {
        return [RLMRealm defaultRealm];
    }
}

- (AFHTTPRequestOperation *)resource:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(RLMObject *result))onSuccess onFailure:(void (^)(NSError *error))onFailure {
    
    NSString* requestString = [NSString stringWithFormat:@"%@/%@/%ld", [_controllerDelegate baseURL], [self resourcePluralName], resourceID];
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:nil
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicc = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RLMRealm *realm = [self requestRealm];
        
            [realm beginWriteTransaction];
            RLMObject* result = [self updateInRealm:realm resource:dicc];
            [realm commitWriteTransaction];
            onSuccess(result);
        });
                                                        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        onFailure(error);
    }];
    
    return op;
}

- (AFHTTPRequestOperation *)resourcesWithParameters:(id)parameters success:(void (^)(RLMObject *))success failure:(void (^)(NSError *))failure {
    return nil;
}

- (AFHTTPRequestOperation *)subResourcesFor:(NSInteger *)resourceID subResourceType:(NSString *)subResourceType parameters:(id)parameters success:(void (^)(RLMObject *))success failure:(void (^)(NSError *))failure {
    return nil;
}

-(RLMObject*)updateInRealm:(RLMRealm*)realm resource:(NSDictionary *)resource {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    //[ALMUser createOrUpdateInRealm:realm withJSONDictionary:resource];
    return nil;
}

-(NSArray*)updateInRealm:(RLMRealm*)realm resources:(NSArray *)resources {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    //[ALMUser createOrUpdateInRealm:realm withJSONArray:array];
    return @[];
}

- (NSString*)resourceSingleName {
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

- (NSString*)resourcePluralName {
    return [NSString stringWithFormat:@"%@s", [self resourceSingleName]];
}

@end
