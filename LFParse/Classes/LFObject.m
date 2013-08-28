//
//  LFObject.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFObject.h"
#import "LFAPIClient.h"

@interface LFObject()
{
    
}

@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *createdAt;

@end

@implementation LFObject

+ (NSDateFormatter *)formatter
{
	NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
	NSDateFormatter *formatter = dictionary[@"iso"];
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
		formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
		dictionary[@"iso"] = formatter;
	}
	return formatter;
}

+ (LFObject *)objectWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className dictionary:nil];
}

+ (LFObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithClassName:className dictionary:dictionary];
}

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithClassName:(NSString *)newClassName dictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        _className = newClassName;
        
        if (dictionary)
        {
            for (NSString *key in dictionary)
                _data[key] = dictionary[key];

            [self fillWithCreationData:dictionary];
        }
    }
    return self;
}

- (void)fillWithCreationData:(NSDictionary *)dictionary
{
    self.objectId = dictionary[@"objectId"];
    self.createdAt = [[LFObject formatter] dateFromString:dictionary[@"createdAt"]];
    self.updatedAt = [[LFObject formatter] dateFromString:dictionary[@"updatedAt"]];
}

- (id)objectForKeyedSubscript:(id)key
{
    id obj = _data[key];
    if ([obj isKindOfClass:[NSDictionary class]] && obj[@"__type"])
    {
        if ([obj[@"__type"] isEqualToString:@"Date"])
        {
            return [[LFObject formatter] dateFromString:obj[@"iso"]];
        }
        else
        {
            return [LFObject objectWithClassName:_className dictionary:obj];
        }
    }
    else
    {
        return obj;
    }
}

- (id)objectForKey:(NSString *)key
{
    return _data[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)key
{
    if ([object isKindOfClass:[LFObject class]])
    {
        _data[key] = @{@"__type" : @"Pointer", @"className": [object className], @"objectId": [object objectId]};
    }
    else
    {
        _data[key] = object;        
    }
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
                                         [self fillWithCreationData:response];
                                         
                                         if (block)
                                             block(YES, nil);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (block)
                                             block(NO, error);
                                     }];
}


@end
