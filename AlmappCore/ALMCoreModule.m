//
//  ALMCoreModule.m
//  AlmappCore
//
//  Created by Patricio López on 28-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMCoreModule.h"

@interface ALMCoreModule ()

@property (weak, nonatomic) id<ALMCoreModuleDelegate> coreModuleDelegate;

@end



@implementation ALMCoreModule

- (id)initWithCoreModuleDelegate:(id<ALMCoreModuleDelegate>)delegate {
    self = [super init];
    if (self) {
        self.coreModuleDelegate = delegate;
    }
    return self;
}

- (ALMSessionManager *)sessionManager {
    return [_coreModuleDelegate moduleSessionManagerFor:[self class]];
}

- (ALMSession *)currentSession {
    return [_coreModuleDelegate moduleCurrentSessionFor:[self class]];
}

- (ALMApiKey *)apiKey {
    return [_coreModuleDelegate moduleApiKeyFor:[self class]];
}

- (NSString *)organizationSlug {
    return [_coreModuleDelegate organizationSlugFor:[self class]];
}

- (RLMRealm *)realmNamed:(NSString *)name {
    return [_coreModuleDelegate module:[self class] realmNamed:name];
}

- (RLMRealm *)defaultRealm {
    return [_coreModuleDelegate moduleDefaultRealmFor:[self class]];
}

- (RLMRealm *)temporalRealm {
    return [_coreModuleDelegate moduleTemporalRealmFor:[self class]];
}

- (RLMRealm *)encryptedRealm {
    return [_coreModuleDelegate moduleEncryptedRealmFor:[self class]];
}

@end
