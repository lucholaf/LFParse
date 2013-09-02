//
//  LFParseTests.m
//  LFParseTests
//
//  Created by lucho on 8/30/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFParseTests.h"
#import "LFBackend.h"
#import "keys.h"

typedef void (^deleteBlock)(NSString *class);

#define START_TEST dispatch_semaphore_t semaphore = dispatch_semaphore_create(0)
#define END_TEST dispatch_semaphore_signal(semaphore)
#define WAIT_TEST while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]

static BOOL _initialized;

@implementation LFParseTests

- (void)initTests
{
    [LFBackend setApplicationId:APP_ID
                      clientKey:REST_KEY];
    
    START_TEST;
    
    __block int ops = 0;
    int totalOps = 2;
    
    deleteBlock delete = ^(NSString *class) {
        LFQuery *query = [LFQuery queryWithClassName:class];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            int total = [objects count];
            __block int count = 0;
            if (total == 0)
            {
                ops++;
                if (ops == totalOps)
                    END_TEST;
            }
            else
            {
                for (LFObject *obj in objects)
                {
                    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        count++;
                        
                        if (count == total)
                        {
                            ops++;
                            if (ops == totalOps)
                                END_TEST;
                        }
                    }];
                }
            }
        }];
    };
    
    delete(@"TestObject");
    delete(@"TestLinkedObject");
    
    WAIT_TEST;
    
    _initialized = YES;
}

- (void)setUp
{
    [super setUp];
    
    if (!_initialized)
        [self initTests];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateLinked
{
    START_TEST;
    
    LFObject *test = [LFObject objectWithClassName:@"TestObject"];
    test[@"key1"] = @"someValueForLinked";
    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        LFObject *linked = [LFObject objectWithClassName:@"TestLinkedObject"];
        linked[@"rel"] = test;
        STAssertNil(error, nil);
        [linked saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            STAssertNil(error, nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (void)testCreateObject
{
    START_TEST;
    
    LFObject *test = [LFObject objectWithClassName:@"TestObject"];
    test[@"key1"] = @"val1";
    test[@"key2"] = @"val2";
    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        STAssertNil(error, nil);
        END_TEST;
    }];

    WAIT_TEST;
    
//    LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
//    [query whereKey:@"someKey1" equalTo:@"someValue5"];
//    [query orderByDescending:@"someKey1"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for (LFObject *object in objects)
//        {
//            NSLog(@"object found %@ created at %@", object.objectId, object.createdAt);
//        }
//    }];
    
//    LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
//    [query whereKey:@"someKey1" equalTo:@"1"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        LFObject *test = objects[0];
//
//        LFQuery *linkedQuery = [LFQuery queryWithClassName:@"TestLinkedObject"];
//        [linkedQuery whereKey:@"createAt" lessThan:test.createdAt];
//        [linkedQuery whereKey:@"rel" equalTo:test];
//        [linkedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            NSLog(@"object fetched %@", objects[0]);
//        }];
//        
//    }];
}

@end