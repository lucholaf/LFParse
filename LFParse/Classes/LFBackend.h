//
//  LFBackend.h
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFObject.h"
#import "LFQuery.h"

@interface LFBackend : NSObject
{
    
}

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;
+ (NSString *)getApplicationId;
+ (NSString *)getClientKey;

@end
