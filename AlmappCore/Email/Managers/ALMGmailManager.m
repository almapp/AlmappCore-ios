//
//  ALMGmailManager.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMGmailManager.h"
#import <GTLGmail.h>

@interface ALMGmailManager ()

@property (strong, nonatomic) GTLServiceGmail *service;

@end


@implementation ALMGmailManager

- (PMKPromise *)setFirstAuthentication:(GTMOAuth2Authentication *)auth {
    return [self.emailController saveAccessToken:auth.accessToken refreshToken:auth.refreshToken code:auth.code expirationDate:auth.expirationDate];
}

- (PMKPromise *)getAccessToken {
    return self.emailController.getValidAccessToken;
}

- (GTLServiceGmail *)service {
    if (!_service) {
        _service = [[GTLServiceGmail alloc] init];
        //_service.shouldFetchNextPages = YES; // 次のリクエストも自動発行
        _service.retryEnabled = YES;
    }
    return _service;
}

- (PMKPromise *)fetchEmailsWithLabels:(NSArray *)labels {
    return [self fetchMessagesWithLabels:labels].then( ^(NSArray *gmailObjects, NSArray *errorObjets) {
        for (GTLGmailMessage *message in gmailObjects) {
            GTLGmailMessagePart *payload = message.payload;
            for (GTLGmailMessagePartHeader *header in payload.headers) {
                if ([header.name isEqualToString:@"Subject"]) {
                    NSString *subject = header.value;
                }
            }
        }
    });
}

- (PMKPromise *)fetchMessagesWithLabels:(NSArray *)labels {
    return [self fetchThreadWithLabels:labels].then( ^(GTLGmailListMessagesResponse *response) {
        NSMutableArray *messageIdentifiers = [NSMutableArray arrayWithCapacity:response.messages.count];
        for (GTLGmailMessage *message in response.messages) {
            [messageIdentifiers addObject:message.identifier];
        }
        return [self fetchMessagesWithIdentifiers:messageIdentifiers];
        
    }).then( ^(GTLBatchResult *results) {
        NSDictionary *successes = results.successes;
        NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:successes.count];
        for (NSString *requestID in successes) {
            GTLGmailMessage *message = [successes objectForKey:requestID];
            [gmailObjects addObject:message];
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
                GTLGmailListMessagesResponse *response = object;
                fulfiller(response);
            }
        }];
    }];
}

- (PMKPromise *)fetchMessagesWithIdentifiers:(NSArray *)identifiers {
    GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
    for (NSString *identifier in identifiers) {
        GTLQueryGmail *query = [GTLQueryGmail queryForUsersMessagesGet];
        query.identifier = identifier;
        [batch addQuery:query];
    }
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
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
