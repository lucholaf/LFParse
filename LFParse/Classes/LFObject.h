//
//  LFObject.h
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFACL;

typedef void (^LFBooleanResultBlock)(BOOL succeeded, NSError *error);

@interface LFObject : NSObject
{
    NSMutableDictionary *_data;
    
    NSString *_className;
}

/*!
 The id of the object.
 */
@property (nonatomic, retain) NSString *objectId;

/*!
 When the object was last updated.
 */
@property (nonatomic, retain, readonly) NSDate *updatedAt;

/*!
 When the object was created.
 */
@property (nonatomic, retain, readonly) NSDate *createdAt;

@property (nonatomic, retain) LFACL *ACL;

@property (readonly) NSString *className;

+ (LFObject *)objectWithClassName:(NSString *)className;
+ (LFObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

+ (id)formatObjectForStore:(id)object;

+ (NSDateFormatter *)formatter;

- (id)initWithClassName:(NSString *)newClassName dictionary:(NSDictionary *)dictionary;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)key;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)saveInBackgroundWithBlock:(LFBooleanResultBlock)block;
- (void)deleteInBackgroundWithBlock:(LFBooleanResultBlock)block;

// protected...
- (void)fillWithCreationData:(NSDictionary *)dictionary;

@end
