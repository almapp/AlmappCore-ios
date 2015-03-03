//
//  ALMGmailManager.m
//  AlmappCore
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <GTLGmail.h>
#import <GTLBase64.h>

#import "ALMGmailManager.h"


NSString *const kGmailProvider = @"GMAIL";
NSInteger const kGmailDefaultResultsPerPage = 20;

NSString *const kGmailLabelINBOX = @"INBOX";
NSString *const kGmailLabelSENT = @"SENT";
NSString *const kGmailLabelDRAFT = @"DRAFT";
NSString *const kGmailLabelSPAM = @"SPAM";
NSString *const kGmailLabelTRASH = @"TRASH";
NSString *const kGmailLabelUNREAD = @"UNREAD";
NSString *const kGmailLabelSTARRED = @"STARRED";
NSString *const kGmailLabelIMPORTANT = @"IMPORTANT";



@implementation NSString (NSAddition)

- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

- (NSString *)removeFirstChar {
    return (self.length > 0) ? [self substringFromIndex:1] : self;
}

- (NSString *)removeLastChar {
    return (self.length > 0) ? [self substringToIndex:[self length] - 1] : self;
}

- (BOOL)hasPrefixes:(NSArray *)prefixes {
    for (NSString *prefix in prefixes) {
        if ([self hasPrefix:prefix]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasSuffixes:(NSArray *)suffixes {
    for (NSString *suffix in suffixes) {
        if ([self hasSuffix:suffix]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)cleanChars:(NSArray *)charsToRemove {
    if ([self hasPrefixes:charsToRemove]) {
        return [[self removeFirstChar] cleanChars:charsToRemove];
    }
    else if ([self hasSuffixes:charsToRemove]) {
        return [[self removeLastChar] cleanChars:charsToRemove];
    }
    else {
        return self;
    }
}

@end



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



@implementation GTLGmailMessagePart (MimeType)

- (BOOL)isHTML {
    return [self.mimeType isEqualToString:@"text/html"];
}

- (BOOL)isPlainText {
    return [self.mimeType isEqualToString:@"text/plain"];
}

@end



@implementation GTLGmailMessagePartBody (MimeType)

- (NSString *)text {
    NSData *data = GTLDecodeWebSafeBase64(self.data);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // [NSString stringWithUTF8String:[data bytes]];
}

@end



@implementation NSDate (Util)

+ (NSArray *)formats {
    static NSArray *formats = nil;
    if (!formats) {
        formats = @[@"EEE, dd MMM yyyy HH:mm:ss Z"
                    ];
    }
    return formats;
}

+ (NSDateFormatter*)dateFormater {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)  {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:enUS];
        //[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
    }
    return formatter;
}

+ (NSDate*)fuckingDate:(NSString *)string {
    NSDateFormatter *formatter = [self dateFormater];
    
    NSString *timezone = [string stringBetweenString:@"(" andString:@")"];
    if (timezone && timezone.length > 0) {
        formatter.timeZone = [NSTimeZone timeZoneWithName:timezone];
    }
    else {
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    }
    
    NSString *cleanString = [[string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)", timezone] withString:@""] cleanChars:@[@" "]];
    
    for (NSString *format in self.formats) {
        formatter.dateFormat = format;
        NSDate *result = [formatter dateFromString:cleanString];
        if (result) {
            return result;
        }
    }
    return nil;
}


@end




@implementation GTLGmailMessage (Realm)

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormat = nil;
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateStyle = NSDateFormatterFullStyle;
        dateFormat.timeStyle = NSDateFormatterFullStyle;
        dateFormat.lenient = YES;
        //dateFormat.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
        //dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    }
    return dateFormat;
}

+ (NSDictionary *)labels {
    static NSDictionary *labelsHash = nil;
    if (!labelsHash) {
        labelsHash = @{kGmailLabelINBOX : @(ALMEmailLabelInbox),
                       kGmailLabelIMPORTANT : @(ALMEmailLabelImportant),
                       kGmailLabelUNREAD : @(ALMEmailLabelUnread),
                       kGmailLabelSPAM : @(ALMEmailLabelSpam),
                       kGmailLabelTRASH : @(ALMEmailLabelTrash),
                       kGmailLabelSTARRED : @(ALMEmailLabelStarred),
                       kGmailLabelSENT : @(ALMEmailLabelSent),
                       kGmailLabelDRAFT : @(ALMEmailLabelDraft)};
    }
    return labelsHash;
}

- (ALMEmailLabel)setupLabelsOn:(ALMEmail *)email {
    email.labels = kEmailDefaultLabel;
    for (NSString *labelString in self.labelIds) {
        NSNumber *labelValue = [GTLGmailMessage labels][labelString];
        if (labelValue) {
            ALMEmailLabel label = [labelValue integerValue];
            email.labels |= label;
        }
    }
    return email.labels;
}

- (ALMEmail *)toSavedRealm:(RLMRealm *)realm {
    return [ALMEmail createOrUpdateInRealm:realm withObject:self.toUnsavedRealm];
}

- (ALMEmail *)toUnsavedRealm {
    BOOL messageID = NO, subject = NO, from = NO, to = NO, cc = NO, cco = NO, date = NO, replyTo = NO;
    
    ALMEmail *email = [ALMEmail createWithIdentifier:self.identifier];
    email.snippet = self.snippet;
    
    [self setupLabelsOn:email];
    
    if (self.payload.isPlainText) {
        GTLGmailMessagePartBody *body = self.payload.body;
        email.bodyPlain = body.text;
    }
    else {
        for (GTLGmailMessagePart *part in self.payload.parts) {
            if (part.isPlainText) {
                email.bodyPlain = part.body.text;
            }
            else if (part.isHTML) {
                email.bodyHTML = part.body.text;
            }
        }
    }
    
    id headers = self.payload.headers;
    //NSLog(@"%@", headers);
    
    for (GTLGmailMessagePartHeader *header in headers) {
        if ([header.name isEqualToString:@"Message-ID"]) {
            // email.messageID = header.value;
            messageID = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Subject"]) {
            email.subject = header.value;
            subject = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"From"]) {
            email.from = [GTLGmailMessage getAddresses:header.value];
            from = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"To"]) {
            email.to = [GTLGmailMessage getAddresses:header.value];
            to = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Cc"]) {
            email.cc = [GTLGmailMessage getAddresses:header.value];
            cc = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Cco"]) {
            email.cco = [GTLGmailMessage getAddresses:header.value];
            cco = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Reply-To"]) {
            //email.replyTo = header.value;
            replyTo = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
        else if ([header.name isEqualToString:@"Date"]) {
            email.date = [NSDate fuckingDate:header.value];
            date = YES;
            if (messageID && subject && from && to && cc && cco && date && replyTo) {
                break;
            }
        }
    }
    
    return email;
}

+ (NSDictionary *)getAddresses:(NSString *)string {
    NSArray *parts = [string componentsSeparatedByString:@","];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:parts.count];
    
    for (NSString *part in parts) {
        NSDictionary *asd = [self getAddress:part];
        [result addEntriesFromDictionary:asd];
    }
    return result;
}

+ (NSDictionary *)getAddress:(NSString *)string {
    static NSArray *charsToRemove = nil;
    if (!charsToRemove) {
        charsToRemove = @[@",", @" ", @"\""];
    }
    
    NSString *cleanedString = [string cleanChars:charsToRemove];
    
    if ([ALMEmail validateEmailAddress:cleanedString]) {
        return @{cleanedString : [NSNull null]};
    }
    else {
        NSString *email = [cleanedString stringBetweenString:@"<" andString:@">"];
        NSString *name = [cleanedString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", email] withString:@""];
        name = [name cleanChars:charsToRemove];

        return @{email : name};
    }
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
    thread.identifier = self.identifier;
    thread.snippet = self.snippet;
    return thread;
}

@end



@implementation GTLBatchResult (Results)

- (NSArray *)successesArray {
    NSDictionary *results = self.successes;
    NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:results.count];
    for (NSString *requestID in results.allKeys) {
        [gmailObjects addObject:[results objectForKey:requestID]];
    }
    return gmailObjects;
}

- (NSArray *)failuresArray {
    NSDictionary *results = self.failures;
    NSMutableArray *gmailObjects = [NSMutableArray arrayWithCapacity:results.count];
    for (NSString *requestID in results.allKeys) {
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

- (NSArray *)inboxFolder {
    return [self.emailController threadsLabeled:ALMEmailLabelInbox inRealm:self.realm ascending:NO];
}

- (NSArray *)sentFolder {
    return [self.emailController threadsLabeled:ALMEmailLabelSent inRealm:self.realm ascending:NO];
}

- (NSArray *)starredFolder {
    return [self.emailController threadsLabeled:ALMEmailLabelStarred inRealm:self.realm ascending:NO];
}

- (NSArray *)spamFolder {
    return [self.emailController threadsLabeled:ALMEmailLabelSpam inRealm:self.realm ascending:NO];
}

- (NSArray *)trashFolder {
    return [self.emailController threadsLabeled:ALMEmailLabelTrash inRealm:self.realm ascending:NO];
}


#pragma mark - Others

+ (NSArray *)identifiersForLabels:(ALMEmailLabel)labels {
    NSMutableArray *array = [NSMutableArray array];
    
    if (labels & ALMEmailLabelInbox) {
        [array addObject:kGmailLabelINBOX];
    }
    else if (labels & ALMEmailLabelSent) {
        [array addObject:kGmailLabelSENT];
    }
    else if (labels & ALMEmailLabelDraft) {
        [array addObject:kGmailLabelDRAFT];
    }
    else if (labels & ALMEmailLabelSpam) {
        [array addObject:kGmailLabelSPAM];
    }
    else if (labels & ALMEmailLabelTrash) {
        [array addObject:kGmailLabelTRASH];
    }
    else if (labels & ALMEmailLabelUnread) {
        [array addObject:kGmailLabelUNREAD];
    }
    else if (labels & ALMEmailLabelStarred) {
        [array addObject:kGmailLabelSTARRED];
    }
    else if (labels & ALMEmailLabelImportant) {
        [array addObject:kGmailLabelIMPORTANT];
    }
    return array;
}

- (NSString *)scope {
    if (!_scope) {
        _scope = [GTMOAuth2Authentication scopeWithStrings:kGTLAuthScopeGmailCompose, kGTLAuthScopeGmailModify, nil];
    }
    return _scope;
}

- (RLMRealm *)realm {
    if (!_realm) {
        _realm = self.session.realm;
    }
    return _realm;
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
        return auth;
        
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

- (PMKPromise *)fetchThreadsWithEmails:(ALMEmailLabel)labels {
    return [self fetchThreadsWithEmailsLabeled:labels count:kGmailDefaultResultsPerPage];
}

- (PMKPromise *)fetchThreadsWithEmailsLabeled:(ALMEmailLabel)labels count:(NSInteger)count {
    return [self fetchThreadsWithEmailsLabeled:labels count:count pageToken:nil];
}

- (PMKPromise *)fetchThreadsWithEmailsLabeled:(ALMEmailLabel)labels count:(NSInteger)count pageToken:(NSString *)pageToken {
    return self.getAccessToken.then ( ^{
        NSArray *identifiers = [self.class identifiersForLabels:labels];
        return [self fetchMessagesWithLabels:identifiers count:count pageToken:pageToken].then( ^(NSArray *gmailObjects, NSArray *errorObjets, GTLGmailListThreadsResponse *response) {
            
            RLMRealm *realm = self.realm;
            [realm beginWriteTransaction];
            
            NSMutableArray *newThreads = [NSMutableArray arrayWithCapacity:gmailObjects.count];
            for (GTLGmailThread *thread in gmailObjects) {
                ALMEmailThread *realmThread = [thread toSavedRealm:realm];
                [newThreads addObject:realmThread];
            }
            
            [realm commitWriteTransaction];
            
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:NO];
            NSArray *sortedArray = [newThreads sortedArrayUsingDescriptors:@[valueDescriptor]];
            
            return PMKManifold(sortedArray, errorObjets, response.nextPageToken);
        });
    });
}

- (PMKPromise *)fetchMessagesWithLabels:(NSArray *)labels count:(NSInteger)count pageToken:(NSString *)pageToken {
    return [self fetchThreadWithLabels:labels count:count pageToken:pageToken].then( ^(GTLGmailListThreadsResponse *response) {
        return [self fetchThreadsWithIdentifiers:response.identifiers].then( ^(GTLBatchResult *results) {
            return PMKManifold(results.successesArray, results.failuresArray, response);
        });
    });
}

- (PMKPromise *)fetchThreadWithLabels:(NSArray *)labels count:(NSInteger)count pageToken:(NSString *)pageToken  {
    GTLQueryGmail *query = [GTLQueryGmail queryForUsersThreadsList];
    query.labelIds = labels;
    query.maxResults = count;
    query.pageToken = pageToken;
    
    return [self.service executeQuery:query];
}


#pragma mark - Modify

- (PMKPromise *)markThreadAsReaded:(ALMEmailThread *)thread readed:(BOOL)readed {
    return [self markThreadsAsReaded:@[thread] readed:readed];
}

- (PMKPromise *)markThreadsAsReaded:(NSArray *)threads readed:(BOOL)readed {
    NSMutableArray *emails = [NSMutableArray array];
    for (ALMEmailThread *thread in threads) {
        for (ALMEmail *email in thread.emails) {
            [emails addObject:email];
        }
    }
    return [self markEmailsAsReaded:emails readed:readed];
}

- (PMKPromise *)markEmailAsReaded:(ALMEmail *)email readed:(BOOL)readed {
    return [self markEmailsAsReaded:@[email] readed:readed];
}

- (PMKPromise *)markEmailsAsReaded:(NSArray *)emails readed:(BOOL)readed {
    if (readed) {
        return [self modifyEmails:emails addLabels:nil removeLabels:@[kGmailLabelUNREAD]];
    }
    else {
        return [self modifyEmails:emails addLabels:@[kGmailLabelUNREAD] removeLabels:nil];
    }
}


- (PMKPromise *)starThread:(ALMEmailThread *)thread starred:(BOOL)starred {
    return [self starThreads:@[thread] starred:starred];
}

- (PMKPromise *)starThreads:(NSArray *)threads starred:(BOOL)starred {
    NSMutableArray *emails = [NSMutableArray array];
    for (ALMEmailThread *thread in threads) {
        for (ALMEmail *email in thread.emails) {
            [emails addObject:email];
        }
    }
    return [self starEmails:emails starred:starred];
}

- (PMKPromise *)starEmail:(ALMEmail *)email starred:(BOOL)starred {
    return [self starEmails:@[email] starred:starred];
}

- (PMKPromise *)starEmails:(NSArray *)emails starred:(BOOL)starred {
    if (starred) {
        return [self modifyEmails:emails addLabels:@[kGmailLabelSTARRED] removeLabels:nil];
    }
    else {
        return [self modifyEmails:emails addLabels:nil removeLabels:@[kGmailLabelSTARRED]];
    }
}


- (PMKPromise *)deleteThread:(ALMEmailThread *)thread markAsReaded:(BOOL)markAsReaded {
    return [self deleteThreads:@[thread] markAsReaded:markAsReaded];
}

- (PMKPromise *)deleteThreads:(NSArray *)threads markAsReaded:(BOOL)markAsReaded {
    NSMutableArray *emails = [NSMutableArray array];
    for (ALMEmailThread *thread in threads) {
        for (ALMEmail *email in thread.emails) {
            [emails addObject:email];
        }
    }
    return [self deleteEmails:emails markAsReaded:markAsReaded];
}

- (PMKPromise *)deleteEmail:(ALMEmail *)email markAsReaded:(BOOL)markAsReaded {
    return [self deleteEmails:@[email] markAsReaded:markAsReaded];
}

- (PMKPromise *)deleteEmails:(NSArray *)emails markAsReaded:(BOOL)markAsReaded {
    NSArray *removeLabels = (markAsReaded) ? @[kGmailLabelUNREAD] : nil;
    return [self modifyEmails:emails addLabels:@[kGmailLabelTRASH] removeLabels:removeLabels];
}



- (PMKPromise *)modifyEmails:(NSArray *)emails addLabels:(NSArray *)addLabels removeLabels:(NSArray *)removeLabels {
    NSMutableDictionary *identifiers = [NSMutableDictionary dictionaryWithCapacity:emails.count];
    for (ALMEmail *email in emails) {
        identifiers[email.identifier] = email;
    }
    
    GTLBatchQuery *batch = [GTLBatchQuery batchQuery];
    for (NSString *identifier in identifiers.allKeys) {
        GTLQueryGmail *query = [GTLQueryGmail queryForUsersMessagesModify];
        query.identifier = identifier;
        query.addLabelIds = addLabels;
        query.removeLabelIds = removeLabels;
        [batch addQuery:query];
    }
    
    return [self batchRequestWith:batch].then( ^(GTLBatchResult *results) {
        
        RLMRealm *realm = ([emails.firstObject realm]) ? (RLMRealm *)[emails.firstObject realm] : self.session.realm;
        
        [realm beginWriteTransaction];
        
        for (GTLGmailMessage *success in results.successesArray) {
            ALMEmail *email = identifiers[[success identifier]];
            [success setupLabelsOn:email];
        }
        
        [realm commitWriteTransaction];
        
        return PMKManifold(emails, results.failuresArray);
    });
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
    return [self.service executeQuery:batch]; // On success returns GTLBatchResult
}


#pragma mark - Google Api

- (GTLServiceGmail *)service {
    if (!_service) {
        _service = [[GTLServiceGmail alloc] init];
        // _service.shouldFetchNextPages = YES;
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
