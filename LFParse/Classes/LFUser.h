//
//  LFUser.h
//  LFParse
//
//  Created by lucho on 9/10/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFObject.h"

@interface LFUser : LFObject
{
    
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

- (void)signUpInBackgroundWithBlock:(LFBooleanResultBlock)block;

@end
