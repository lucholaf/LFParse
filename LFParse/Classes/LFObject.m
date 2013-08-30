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
    if (dictionary[@"objectId"]) self.objectId = dictionary[@"objectId"];
    if (dictionary[@"createdAt"]) self.createdAt = [[LFObject formatter] dateFromString:dictionary[@"createdAt"]];
    if (dictionary[@"updatedAt"]) self.updatedAt = [[LFObject formatter] dateFromString:dictionary[@"updatedAt"]];
}

+ (id)formatObjectForStore:(id)object
{
    if ([object isKindOfClass:[LFObject class]])
    {
        return @{@"__type" : @"Pointer", @"className": [object className], @"objectId": [object objectId]};
    }
    else if ([object isKindOfClass:[NSDate class]])
    {
        return @{@"__type" : @"Date", @"iso": [[LFObject formatter] stringFromDate:object]};
    }
    else
    {
        return object;
    }
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
    return self[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)key
{
    _data[key] = [LFObject formatObjectForStore:object];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    self[key] = object;
}

- (void)deleteInBackgroundWithBlock:(LFBooleanResultBlock)block
{
    [[LFAPIClient sharedInstance] deletePath:$(@"classes/%@/%@", _className, self.objectId) parameters:_data
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         if (block)
                                             block(YES, nil);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (block)
                                             block(NO, error);
                                     }];
}

- (void)saveInBackgroundWithBlock:(LFBooleanResultBlock)block
{
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id response) {
        [self fillWithCreationData:response];
        
        if (block)
            block(YES, nil);
    };
    
    void (^failBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
            block(NO, error);
    };
    
    [[LFAPIClient sharedInstance] setParameterEncoding:AFJSONParameterEncoding];
    
    if (self.objectId)
    {
        [[LFAPIClient sharedInstance] putPath:$(@"classes/%@/%@", _className, self.objectId) parameters:_data
                                       success:successBlock
                                       failure:failBlock];
    }
    else
    {
        [[LFAPIClient sharedInstance] postPath:$(@"classes/%@", _className) parameters:_data
                                       success:successBlock
                                       failure:failBlock];        
    }
}


@end
