//
//  LFAppDelegate.m
//  LFParse
//
//  Created by lucho on 8/28/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFAppDelegate.h"
#import "LFBackend.h"
#import "keys.h"

@implementation LFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [LFBackend setApplicationId:APP_ID
                  clientKey:REST_KEY];
    
//    LFObject *test = [LFObject objectWithClassName:@"TestObject"];
//    test[@"someKey1"] = @"someValue5";
//    test[@"someKey2"] = @"someValue6";
//    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"object saved %@", error);
//    }];
    
    LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
//    [query whereKey:@"someKey1" equalTo:@"someValue5"];
    [query orderByDescending:@"someKey1"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (LFObject *object in objects)
        {
            NSLog(@"object found %@ created at %@", object.objectId, object.createdAt);
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
