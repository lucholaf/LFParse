//
//  LFAPIClient.h
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define BASE_URL @"https://api.parse.com/1/"

@interface LFAPIClient : AFHTTPClient
{
    
}

+ (id)sharedInstance;

@end
