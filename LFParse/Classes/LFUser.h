//
//  LFUser.h
//  LFParse
//
//  Created by lucho on 9/10/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFObject.h"

@class LFUser;

typedef void (^LFUserResultBlock)(LFUser *user, NSError *error);

@interface LFUser : LFObject
{
    
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

+ (LFUser *)user;
+ (instancetype)currentUser;
+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(LFUserResultBlock)block;
- (void)signUpInBackgroundWithBlock:(LFBooleanResultBlock)block;

@end