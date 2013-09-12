//
//  LFUser.m
//  LFParse
//
//  Created by lucho on 9/10/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFUser.h"
#import "LFAPIClient.h"

static LFUser *theCurrentUser;

@implementation LFUser

+ (LFUser *)user
{
    return (LFUser *)[self objectWithClassName:@"_User"];
}

+ (instancetype)currentUser
{
    return theCurrentUser;
}

- (void)fillWithUserCreationData:(NSDictionary *)dictionary
{
    if (dictionary[@"sessionToken"]) _data[@"sessionToken"] = dictionary[@"sessionToken"];
}

- (void)setAsCurrentUser
{
    theCurrentUser = self;
}

- (void)signUpInBackgroundWithBlock:(LFBooleanResultBlock)block
{
    if (!self.username || !self.password)
    {
        block(NO, [NSError errorWithDomain:@"" code:0 userInfo:@{@"error" : @"username or password missing"}]);
        return;
    }
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id response) {
        [self fillWithCreationData:response];

        [self fillWithUserCreationData:response];
        
        [self setAsCurrentUser];

        if (block)
            block(YES, nil);
    };
    
    void (^failBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
            block(NO, error);
    };
    
    [[LFAPIClient sharedInstance] setParameterEncoding:AFJSONParameterEncoding];
    
    [[LFAPIClient sharedInstance] postPath:$(@"users") parameters:_data
                                   success:successBlock
                                   failure:failBlock];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(LFUserResultBlock)block
{
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id response) {
        LFUser *user = [LFUser user];
        
        [user fillWithCreationData:response];
        
        [user fillWithUserCreationData:response];
        
        [user setAsCurrentUser];
        
        if (block)
            block(user, nil);
    };
    
    void (^failBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
            block(nil, error);
    };
    
    [[LFAPIClient sharedInstance] setParameterEncoding:AFJSONParameterEncoding];
    
    [[LFAPIClient sharedInstance] getPath:$(@"login") parameters:@{@"username":username, @"password":password}
                                   success:successBlock
                                   failure:failBlock];
    
}

- (NSString *)username
{
    return _data[@"username"];
}

- (NSString *)password
{
    return _data[@"password"];
}

- (void)setUsername:(NSString *)username
{
    _data[@"username"] = [username copy];
}

- (void)setPassword:(NSString *)password
{
    _data[@"password"] = [password copy];
}


@end
