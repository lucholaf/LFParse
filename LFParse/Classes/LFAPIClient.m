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
        [self setDefaultHeader:@"Accept" value:@"application/json"];
		[self setDefaultHeader:@"X-Parse-Application-Id" value:[LFBackend getApplicationId]];
		[self setDefaultHeader:@"X-Parse-REST-API-Key" value:[LFBackend getClientKey]];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    if ([LFUser currentUser] && [LFUser currentUser][@"sessionToken"])
        [self setDefaultHeader:@"X-Parse-Session-Token" value:[LFUser currentUser][@"sessionToken"]];
    
    return [super requestWithMethod:method path:path parameters:parameters];
}


@end
