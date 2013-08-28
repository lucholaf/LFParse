//
//  LFAPIClient.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFAPIClient.h"
#import "LFBackend.h"

@implementation LFAPIClient

+ (id)sharedInstance {
    static LFAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[LFAPIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:BASE_URL]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"Accept" value:@"application/json"];
		[self setDefaultHeader:@"X-Parse-Application-Id" value:[LFBackend getApplicationId]];
		[self setDefaultHeader:@"X-Parse-REST-API-Key" value:[LFBackend getClientKey]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

@end
