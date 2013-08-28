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
}

+ (LFQuery *)queryWithClassName:(NSString *)className;
- (id)initWithClassName:(NSString *)newClassName;

- (void)whereKey:(NSString *)key equalTo:(id)object;

- (void)findObjectsInBackgroundWithBlock:(LFArrayResultBlock)block;

@end
