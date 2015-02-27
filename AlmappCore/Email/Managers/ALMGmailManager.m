//
//  ALMGmailManager.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <GTLGmail.h>

#import "ALMGmailManager.h"


NSString *const kGmailProvider = @"GMAIL";

NSString *const kGmailLabelINBOX = @"INBOX";
NSString *const kGmailLabelSPAM = @"SPAM";
NSString *const kGmailLabelTRASH = @"TRASH";
NSString *const kGmailLabelUNREAD = @"UNREAD";
NSString *const kGmailLabelSTARRED = @"STARRED";
NSString *const kGmailLabelIMPORTANT = @"IMPORTANT";


@implementation GTLServiceGmail (Promise)

- (PMKPromise *)executeQuery:(id<GTLQueryProtocol>)query {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id response, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                rejecter(error);
            }
            else {
                fulfiller(response);
            }
        }];
    }];
}

@end



@implementation GTLGmailListThreadsResponse (Identifiers)

- (NSArray *)identifiers {
    NSMutableArray *identifiers = [NSMutableArray array];
    for (GTLGmailThread *item in self.threads) {
        [identifiers addObject:item.identifier];
    }
    return identifiers;
}

@end



@implementation GTLGmailListMessagesResponse (Identifiers)

- (NSArray *)identifiers {
    NSMutableArray *identifiers = [NSMutableArray array];
    for (GTLGmailThread *item in self.messages) {
        [identifiers addObject:item.identifier];
    }
    return identifiers;
}

@end



@implementation GTLGmailMessage (Realm)

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormat = nil;
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    }
    return dateFormat;
}

- (ALMEmail *)toSavedRealm:(RLMRealm *)realm {
    return [ALMEmail createOrUpdateInRealm:realm withObject:self.toUnsavedRealm];
}

- (ALMEmail *)toUnsavedRealm {
    BOOL messageID = NO, subject = NO, to = NO, from = NO, date = NO, replyTo = NO;
    
    ALMEmail *email = [[ALMEmail alloc] init];
    email.snippet = self.snippet;
    
    for (GTLGmailMessagePartHeader *header in self.payload.headers) {
        // NSLog(@"%@ : %@", header.name, header.value);
        
        if ([header.name isEqualToString:@"Message-ID"]) {
            email.messageID = header.value;
            messageID = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Subject"]) {
            email.subject = header.value;
            subject = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"To"]) {
            email.to = header.value;
            to = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"From"]) {
            email.from = header.value;
            from = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Reply-To"]) {
            email.replyTo = header.value;
            replyTo = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Date"]) {
            email.date = [[GTLGmailMessage dateFormatter] dateFromString:header.value];
            date = YES;
            if (messageID && subject && to && from && date && replyTo) {
                break;
            }
        }
    }
    
    return email;
}

@end



@implementation GTLGmailThread (Realm)

- (ALMEmailThread *)toSavedRealm:(RLMRealm *)realm {
    ALMEmailThread *thread = [ALMEmailThread createOrUpdateInRealm:realm withObject:self.toUnsavedRealm];
    
    for (GTLGmailMessage *message in self.messages) {
        [thread.emails addObject:[message toSavedRealm:realm]];
    }
    
    return thread;
}

- (ALMEmailThread *)toUnsavedRealm {
    ALMEmailThread *thread = [[ALMEmailThread alloc] init];
    thread.threadID = self.identifier;
    thread.snippet = self.snippet;
    return thread;
}

@end



@implementation GTLBatchResult (Results)

- (NSArray *)successesArray {
    NSDictionary *results = self.successes;
    NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:results.count];
    for (NSString *requestID in results) {
        [gmailObjects addObject:[results objectForKey:requestID]];
    }
    return gmailObjects;
}

- (NSArray *)failuresArray {
    NSDictionary *results = self.failures;
    NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:results.count];
    for (NSString *requestID in results) {
        [gmailObjects addObject:[results objectForKey:requestID]];
    }
    return gmailObjects;
}

@end



@interface ALMGmailManager ()

@property (strong, nonatomic) GTLServiceGmail *service;

@end



@implementation ALMGmailManager


#pragma mark - Folders

- (ALMEmailFolder *)inboxFolder {
    return [self.emailController folder:kGmailLabelINBOX];
}

- (ALMEmailFolder *)sentFolder {
    return [self.emailController folder:nil];
}

- (ALMEmailFolder *)starredFolder {
    return [self.emailController folder:kGmailLabelSTARRED];
}

- (ALMEmailFolder *)spamFolder {
    return [self.emailController folder:kGmailLabelSPAM];
}

- (ALMEmailFolder *)threadFolder {
    return [self.emailController folder:kGmailLabelTRASH];
}

- (NSString *)scope {
    if (!_scope) {
        _scope = [GTMOAuth2Authentication scopeWithStrings:kGTLAuthScopeGmailCompose, kGTLAuthScopeGmailModify, nil];
    }
    return _scope;
}


#pragma mark - Authentication

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth {
    self.service.authorizer = auth;
    return [self.emailController saveAccessToken:auth.accessToken refreshToken:auth.refreshToken code:auth.code expirationDate:auth.expirationDate provider:kGmailProvider];
}

- (PMKPromise *)getAccessToken {
    return self.emailController.getValidAccessToken.then( ^(ALMEmailToken *token) {
        if (!self.service.authorizer) {
            self.service.authorizer = [[GTMOAuth2Authentication alloc] init];
        }
        
        NSAssert(self.apiKey != nil, @"Must set an apikey, see ALMGmalManager");
        
        GTMOAuth2Authentication *auth = self.service.authorizer;
        auth.clientID = self.apiKey.clientID;
        auth.clientSecret = self.apiKey.clientSecret;
        auth.scope = self.scope;
        auth.redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
        auth.tokenURL = [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"];
        auth.serviceProvider = @"Google";
        auth.tokenType = @"Bearer";
        auth.accessToken = token.accessToken;
        auth.expirationDate = token.expiresAt;
    }).catch ( ^(NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 404) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(gmailManager:tokenNotFound:)]) {
                [self.delegate gmailManager:self tokenNotFound:error];
            }
        }
        return error;
    });
}


#pragma mark - Fetching

- (PMKPromise *)fetchEmailsInFolder:(ALMEmailFolder *)folder {
    return self.getAccessToken.then ( ^{
        return [self fetchMessagesWithLabels:@[folder.identifier]].then( ^(NSArray *gmailObjects, NSArray *errorObjets) {
            
            RLMRealm *realm = folder.realm;
            [realm beginWriteTransaction];
            
            for (GTLGmailThread *thread in gmailObjects) {
                ALMEmailThread *realmThread = [thread toSavedRealm:realm];
                [folder.threads addObject:realmThread];
            }
            
            [realm commitWriteTransaction];
            
            return folder.threads;
        });
    });
}

- (PMKPromise *)fetchMessagesWithLabels:(NSArray *)labels {
    return [self fetchThreadWithLabels:labels].then( ^(GTLGmailListThreadsResponse *response) {
        return [self fetchThreadsWithIdentifiers:response.identifiers];
        
    }).then( ^(GTLBatchResult *results) {
        return PMKManifold(results.successesArray, results.failuresArray);
    });
}

- (PMKPromise *)fetchThreadWithLabels:(NSArray *)labels; {
    GTLQueryGmail *query = [GTLQueryGmail queryForUsersThreadsList];
    query.labelIds = labels;
    query.maxResults = 20;
    
    return [self.service executeQuery:query];
}


#pragma mark - Batch requests

- (PMKPromise *)fetchThreadsWithIdentifiers:(NSArray *)identifiers {
    GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
    for (NSString *identifier in identifiers) {
        GTLQueryGmail *query = [GTLQueryGmail queryForUsersThreadsGet];
        query.identifier = identifier;
        [batch addQuery:query];
    }
    return [self batchRequestWith:batch];
}

- (PMKPromise *)fetchMessagesWithIdentifiers:(NSArray *)identifiers {
    GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
    for (NSString *identifier in identifiers) {
        GTLQueryGmail *query = [GTLQueryGmail queryForUsersMessagesGet];
        query.identifier = identifier;
        [batch addQuery:query];
    }
    return [self batchRequestWith:batch];
}

- (PMKPromise *)batchRequestWith:(GTLBatchQuery *)batch {
    return [self.service executeQuery:batch];
}


#pragma mark - Google Api

- (GTLServiceGmail *)service {
    if (!_service) {
        _service = [[GTLServiceGmail alloc] init];
        //_service.shouldFetchNextPages = YES;
        _service.retryEnabled = YES;
    }
    return _service;
}

- (BOOL)isSignedIn {
    return self.service.authorizer && self.service.authorizer.canAuthorize;
}

- (void)signOut {
    if (self.service.authorizer) {
        self.service.authorizer = nil;
    }
}

@end
