//
//  ALMEmail.h
//  AlmappCore
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Realm+JSON/RLMObject+JSON.h>
#import <Realm+JSON/RLMObject+Copying.h>
#import "RLMArray+Extras.h"
#import "RLMResults+Extras.h"

@interface ALMEmail : RLMObject

@property NSString *messageID;
@property NSString *subject;
@property NSString *to;
@property NSString *from;
@property NSString *replyTo;
@property NSString *snippet;
@property NSDate *date;

//@property NSString *toName;
//@property NSString *toEmail;
//@property NSString *fromName;
//@property NSString *fromEmail;
//@property NSString *replyToName;
//@property NSString *replyToEmail;

@property (readonly) NSArray *threads;

@end
RLM_ARRAY_TYPE(ALMEmail)