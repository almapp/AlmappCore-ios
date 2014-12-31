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
- (RLMRealm*)requestTemporalRealm;

@end

@implementation ALMController

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self)
    {
        _controllerDelegate = [ALMCore sharedInstance];
        _saveToPersistenceStore = YES;
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

#pragma mark - Managers

- (AFHTTPRequestOperationManager*)requestManager {
    return [_controllerDelegate requestManager];
}

- (RLMRealm *)requestRealm {
    return [_controllerDelegate requestRealm];
}

- (RLMRealm *)requestTemporalRealm {
    return [_controllerDelegate requestTemporalRealm];
}

#pragma mark - URL

- (NSString *)buildUrlWithPath:(NSString *)path resourceID:(NSUInteger)resourceID {
    return [[self buildUrlWithPath:path] stringByAppendingString:[NSString stringWithFormat:@"/%ld", resourceID]];
}

- (NSString *)buildUrlWithPath:(NSString *)path {
    if(path != nil) {
        return [NSString stringWithFormat:@"%@/%@", [_controllerDelegate baseURL], path];
    }
    else {
        return [NSString stringWithFormat:@"%@/%@", [_controllerDelegate baseURL], [self resourcePluralName]];
    }
}

- (NSString *)buildUrl {
    return [self buildUrlWithPath:[self resourcePluralName]];
}

- (NSString *)buildUrlForResource:(NSUInteger)resourceID {
    return [[self buildUrl] stringByAppendingString:[NSString stringWithFormat:@"/%ld", resourceID]];
}

#pragma mark - Requests operations

- (AFHTTPRequestOperation *)resource:(long)resourceID parameters:(id)parameters onSuccess:(void (^)(RLMObject *result))onSuccess onFailure:(void (^)(NSError *error))onFailure {
    
    NSString* requestString = [self buildUrlForResource:resourceID];
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.almapp.requestsbgqueue", NULL);
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicc = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            onSuccess([self commitResource:dicc]);
        });
                                                        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        onFailure(error);
    }];
    
    return op;
}

- (AFHTTPRequestOperation *)resourcesFromPath:(NSString *)path parameters:(id)parameters onSuccess:(void (^)(NSArray *))onSuccess onFailure:(void (^)(NSError *))onFailure {
    
    NSString* requestString = [self buildUrlWithPath:path];
    
    AFHTTPRequestOperation *op = [[self requestManager] GET:requestString
                                                 parameters:parameters
                                                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        
                                                        NSArray *array = responseObject;
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            onSuccess([self commitResources:array]);
                                                        });
                                                        
                                                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        NSLog(@"Error: %@", error);
                                                        onFailure(error);
                                                    }];
    
    return op;
}

#pragma mark - Persistence

-(RLMObject*)commitResource:(NSDictionary*)resource {
    RLMRealm *realm = (_saveToPersistenceStore) ? [self requestRealm] : [self requestTemporalRealm];

    [realm beginWriteTransaction];
    RLMObject* result = [self updateInRealm:realm resource:resource];
    [realm commitWriteTransaction];
    return result;
}

-(NSArray*)commitResources:(NSArray*)resources {
    RLMRealm *realm = (_saveToPersistenceStore) ? [self requestRealm] : [self requestTemporalRealm];
    
    [realm beginWriteTransaction];
    NSArray* result = [self updateInRealm:realm resources:resources];
    [realm commitWriteTransaction];
    return result;
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

#pragma mark - Resource paths (names)

- (NSString*)resourceSingleName {
    return @"";
}

- (NSString*)resourcePluralName {
    BOOL ios = YES;
    if(ios) {
        NSString *controllerName = NSStringFromClass([self class]);
        //unsigned long lenght = controllerName.length - 3 - 9;
        //return [controllerName substringWithRange:[NSMakeRange(3, lenght)];
        
        controllerName = [controllerName stringByReplacingOccurrencesOfString:@"ALM" withString:@""];
        return [[controllerName stringByReplacingOccurrencesOfString:@"Controller" withString:@""] lowercaseString];
    }
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

@end
