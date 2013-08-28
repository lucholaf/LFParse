//
//  LFObject.h
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LFBooleanResultBlock)(BOOL succeeded, NSError *error);

@interface LFObject : NSObject
{
    NSMutableDictionary *_data;
    
    NSString *_className;
}

+ (instancetype)objectWithClassName:(NSString *)className;

- (id)initWithClassName:(NSString *)newClassName;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)key;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)saveInBackgroundWithBlock:(LFBooleanResultBlock)block;

@end
