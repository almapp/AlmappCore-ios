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



@interface ALMGmailManager ()

@property (strong, nonatomic) GTLServiceGmail *service;

@end



@implementation ALMGmailManager


#pragma mark - Labels

- (ALMEmailLabel *)inboxLabel {
    return [self.emailController label:kGmailLabelINBOX];
}

- (ALMEmailLabel *)sentLabel {
    return [self.emailController label:nil];
}

- (ALMEmailLabel *)starredLabel {
    return [self.emailController label:kGmailLabelSTARRED];
}

- (ALMEmailLabel *)spamLabel {
    return [self.emailController label:kGmailLabelSPAM];
}

- (ALMEmailLabel *)threadLabel {
    return [self.emailController label:kGmailLabelTRASH];
}


#pragma mark - Authentication

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth {
    return [self.emailController saveAccessToken:auth.accessToken refreshToken:auth.refreshToken code:auth.code expirationDate:auth.expirationDate provider:kGmailProvider];
}

- (PMKPromise *)getAccessToken {
    return self.emailController.getValidAccessToken.then( ^(ALMEmailToken *token) {
        ALMApiKey *apiKey = [self.delegate gmailApiKey:self];
        
        GTMOAuth2Authentication *auth = [[GTMOAuth2Authentication alloc] init];
        auth.clientID = apiKey.clientID;
        auth.clientSecret = apiKey.clientSecret;
        auth.scope = [self.delegate gmailScope:self];
        auth.redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
        auth.tokenURL = [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"];
        auth.serviceProvider = @"Google";
        auth.tokenType = @"Bearer";
        auth.accessToken = token.accessToken;
        auth.expirationDate = token.expiresAt;
        
        self.service.authorizer = auth;
    });
}


#pragma mark - Fetching

- (PMKPromise *)fetchEmailsWithLabel:(ALMEmailLabel *)label {
    return self.getAccessToken.then ( ^{
        return [self fetchMessagesWithLabels:@[label.identifier]].then( ^(NSArray *gmailObjects, NSArray *errorObjets) {
            
            RLMRealm *realm = label.realm;
            [realm beginWriteTransaction];
            
            for (GTLGmailThread *thread in gmailObjects) {
                ALMEmailThread *realmThread = [thread toSavedRealm:realm];
                [label.threads addObject:realmThread];
            }
            
            [realm commitWriteTransaction];
            
            return label;
        });
    });
}


- (PMKPromise *)fetchMessagesWithLabels:(NSArray *)labels {
    return [self fetchThreadWithLabels:labels].then( ^(GTLGmailListThreadsResponse *response) {
        NSMutableArray *threadIdentifiers = [NSMutableArray array];
        for (GTLGmailThread *thread in response.threads) {
            [threadIdentifiers addObject:thread.identifier];
        }
        return [self fetchThreadsWithIdentifiers:threadIdentifiers];
        
    }).then( ^(GTLBatchResult *results) {
        NSDictionary *successes = results.successes;
        NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:successes.count];
        for (NSString *requestID in successes) {
            GTLGmailThread *thread = [successes objectForKey:requestID];
            [gmailObjects addObject:thread];
        }
        
        NSDictionary *failures = results.failures;
        NSMutableArray *errorObjets = [NSMutableArray arrayWithCapacity:failures.count];
        for (NSString *requestID in failures) {
            GTLErrorObject *errorObject = [failures objectForKey:requestID];
            [errorObjets addObject:errorObject];
        }
        return PMKManifold(gmailObjects, errorObjets);
    });
}

- (PMKPromise *)fetchThreadsWithIdentifiers:(NSArray *)identifiers {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
        for (NSString *identifier in identifiers) {
            GTLQueryGmail *query = [GTLQueryGmail queryForUsersThreadsGet];
            query.identifier = identifier;
            [batch addQuery:query];
        }
        
        [self.service executeQuery:batch completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                rejecter(error);
            }
            else {
                GTLBatchResult *batchResult = object;
                fulfiller(batchResult);
            }
        }];
    }];
}

- (PMKPromise *)fetchThreadWithLabels:(NSArray *)labels; {
    GTLQueryGmail *query = [GTLQueryGmail queryForUsersThreadsList];
    query.labelIds = labels;
    query.maxResults = 20;
    // query.userId = @"me";
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                rejecter(error);
            }
            else {
                GTLGmailListThreadsResponse *response = object;
                fulfiller(response);
            }
        }];
    }];
}

- (PMKPromise *)fetchMessagesWithIdentifiers:(NSArray *)identifiers {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
        for (NSString *identifier in identifiers) {
            GTLQueryGmail *query = [GTLQueryGmail queryForUsersMessagesGet];
            query.identifier = identifier;
            [batch addQuery:query];
        }
        
        [self.service executeQuery:batch completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                rejecter(error);
            }
            else {
                GTLBatchResult *batchResult = object;
                fulfiller(batchResult);
            }
        }];
    }];
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
    if (!self.service.authorizer) {
        self.service.authorizer = [self.delegate gmailAuthenticationFor:self];
    }
    return self.service.authorizer.canAuthorize;
}

- (void)signOut {
    if (self.service.authorizer) {
        self.service.authorizer = nil;
    }
}

@end
