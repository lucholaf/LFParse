//
//  LFQuery.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFQuery.h"
#import "LFAPIClient.h"

@implementation LFQuery

+ (LFQuery *)queryWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className];
}

- (id)init
{
    self = [super init];
    if (self) {
        _wheres = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithClassName:(NSString *)newClassName
{
    self = [self init];
    if (self) {
        _className = newClassName;
    }
    return self;
}

- (void)whereKey:(NSString *)key equalTo:(id)object
{
    _wheres[key] = object;
}

- (void)findObjectsInBackgroundWithBlock:(LFArrayResultBlock)block
{
    NSString *data = @"where={\"someKey1\":\"someValue3\"}";
    NSString *encodedData = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[LFAPIClient sharedInstance] getPath:$(@"classes/%@?%@", _className, encodedData) parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id response) {
                                       block(response[@"results"], nil);
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       block(nil, error);
                                   }];
}

@end
