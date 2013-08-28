//
//  LFQuery.h
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LFArrayResultBlock)(NSArray *objects, NSError *error);

@interface LFQuery : NSObject
{
    NSString *_className;
    NSMutableDictionary *_wheres;
    NSMutableDictionary *_wheresNot;
    
    NSString *_order;    
}

+ (LFQuery *)queryWithClassName:(NSString *)className;
- (id)initWithClassName:(NSString *)newClassName;

- (void)whereKey:(NSString *)key equalTo:(id)object;
- (void)whereKey:(NSString *)key notEqualTo:(id)object;
- (void)whereKey:(NSString *)key greaterThan:(id)object;
- (void)whereKey:(NSString *)key lessThan:(id)object;

- (void)orderByAscending:(NSString *)key;
- (void)orderByDescending:(NSString *)key;

- (void)findObjectsInBackgroundWithBlock:(LFArrayResultBlock)block;

@end
