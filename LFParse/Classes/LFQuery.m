//
//  LFQuery.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFQuery.h"
#import "LFObject.h"
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
        _wheresNot = [NSMutableDictionary dictionary];
        _order = @"";        
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
    _wheres[key] = [LFObject formatObjectForStore:object];
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object
{
    _wheresNot[key] = @{@"$ne": [LFObject formatObjectForStore:object]};
}

- (void)whereKey:(NSString *)key greaterThan:(id)object
{
    _wheresNot[key] = @{@"$gt": [LFObject formatObjectForStore:object]};
}

- (void)whereKey:(NSString *)key lessThan:(id)object
{
    _wheresNot[key] = @{@"$lt": [LFObject formatObjectForStore:object]};
}

- (void)orderByAscending:(NSString *)key
{
    _order = key;
}

- (void)orderByDescending:(NSString *)key
{
    _order = $(@"-%@", key);
}

- (void)findObjectsInBackgroundWithBlock:(LFArrayResultBlock)block
{
    NSMutableDictionary *totalDict = [NSMutableDictionary dictionary];
    NSArray *dicts = @[_wheres, _wheresNot];
    
    for (NSDictionary *dict in dicts)
        for (NSString *key in dict)
            totalDict[key] = dict[key];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:totalDict options:0 error:nil];
    NSString *data = $(@"where=%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    NSString *encodedData = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *orderData = $(@"order=%@", _order);
    
    [[LFAPIClient sharedInstance] getPath:$(@"classes/%@?%@&%@", _className, encodedData, orderData) parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id response) {
                                       NSMutableArray *objects = [NSMutableArray array];
                                       for (NSDictionary *dict in response[@"results"])
                                       {
                                           LFObject *obj = [LFObject objectWithClassName:_className dictionary:dict];
                                           [objects addObject:obj];
                                       }
                                       block(objects, nil);
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       block(nil, error);
                                   }];
}

@end
