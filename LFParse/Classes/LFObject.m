//
//  LFObject.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFObject.h"
#import "LFAPIClient.h"

@implementation LFObject

+ (instancetype)objectWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className];
}

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionary];
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

- (id)objectForKeyedSubscript:(id)key
{
    return _data[key];
}

- (id)objectForKey:(NSString *)key
{
    return _data[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)key
{
    _data[key] = object;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    _data[key] = object;
}

- (void)saveInBackgroundWithBlock:(LFBooleanResultBlock)block
{
    [[LFAPIClient sharedInstance] setParameterEncoding:AFJSONParameterEncoding];
    [[LFAPIClient sharedInstance] postPath:$(@"classes/%@", _className) parameters:_data
                                     success:^(AFHTTPRequestOperation *operation, id response) {
                                         if (block)
                                             block(YES, nil);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (block)
                                             block(NO, error);
                                     }];
}


@end
