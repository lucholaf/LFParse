//
//  LFBackend.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFBackend.h"

static NSString *applicationIdLF;
static NSString *clientKeyLF;

@implementation LFBackend

+ (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey
{
    applicationIdLF = applicationId;
    clientKeyLF = clientKey;
}

@end
