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
#import "LFAPIClient.h"

typedef void (^deleteBlock)(NSString *class);

#define START_TEST dispatch_semaphore_t semaphore = dispatch_semaphore_create(0)
#define END_TEST dispatch_semaphore_signal(semaphore)
#define WAIT_TEST while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]

static BOOL _initialized;

@implementation LFParseTests

- (void)clearObjects:(NSArray *)classes
{
    [LFBackend setApplicationId:APP_ID
                      clientKey:REST_KEY];
    
    START_TEST;
    
    __block int ops = 0;
    int totalOps = [classes count];
    
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
    
    for (NSString *class in classes)
        delete(class);
    
    WAIT_TEST;
    
    _initialized = YES;
}

- (void)clearTestObjects
{
    [self clearObjects:@[@"TestObject", @"TestLinkedObject"]];
}

- (void)setUp
{
    [super setUp];
    
    if (!_initialized)
        [self clearTestObjects];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateObject
{
    START_TEST;
    
    LFObject *test = [LFObject objectWithClassName:@"TestObject"];
    test[@"key1"] = @"val1";
    test[@"key2"] = @"val2";
    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        STAssertNil(error, nil);
        STAssertNotNil(test.objectId, nil);
        END_TEST;
    }];

    WAIT_TEST;
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
        STAssertNotNil(test.objectId, nil);
        [linked saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            STAssertNil(error, nil);
            STAssertNotNil(linked.objectId, nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (void)createQueryObjects:(dispatch_block_t)done
{
    LFObject *test1 = [LFObject objectWithClassName:@"TestObject"];
    test1[@"key1"] = @"1";
    [test1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        LFObject *test2 = [LFObject objectWithClassName:@"TestObject"];
        test2[@"key1"] = @"2";
        
        [test2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            LFObject *test3 = [LFObject objectWithClassName:@"TestObject"];
            test3[@"key1"] = @"3";
            
            [test3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                done();
            }];
        }];
    }];
}

- (void)testBasicQuery
{
    START_TEST;

    [self clearTestObjects];
    
    [self createQueryObjects:^{
        LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
        [query whereKey:@"key1" equalTo:@"2"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            STAssertNil(error, nil);
            STAssertTrue(1 == [objects count], nil);
            END_TEST;
        }];
    }];    
    
    WAIT_TEST;
}

- (void)testWhereNEQuery
{
    START_TEST;
    
    [self clearTestObjects];

    [self createQueryObjects:^{
        LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
        [query whereKey:@"key1" notEqualTo:@"2"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            STAssertNil(error, nil);
            STAssertTrue(2 == [objects count], nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (void)testWhereGTQuery
{
    START_TEST;
    
    [self clearTestObjects];
    
    [self createQueryObjects:^{
        LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
        [query whereKey:@"key1" greaterThan:@"1"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            STAssertNil(error, nil);
            STAssertTrue(2 == [objects count], nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (void)testWhereLTQuery
{
    START_TEST;
    
    [self clearTestObjects];
    
    [self createQueryObjects:^{
        LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
        [query whereKey:@"key1" lessThan:@"2"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            STAssertNil(error, nil);
            STAssertTrue(1 == [objects count], nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (void)testSortQuery
{
    START_TEST;
    
    [self clearTestObjects];
    
    [self createQueryObjects:^{
        LFQuery *query = [LFQuery queryWithClassName:@"TestObject"];
        [query orderByDescending:@"key1"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            STAssertNil(error, nil);
            STAssertTrue(3 == [objects[0][@"key1"] intValue], nil);
            STAssertTrue(2 == [objects[1][@"key1"] intValue], nil);
            STAssertTrue(1 == [objects[2][@"key1"] intValue], nil);
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

- (NSString *)createNewUdid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}

- (void)testUserCreation
{
    START_TEST;
    
    LFUser *user = [LFUser user];
    user.username = $(@"testUser%@", [self createNewUdid]);
    user.password = @"what?is?this";
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        STAssertNil(error, nil);
        STAssertNotNil([LFUser currentUser], nil);
        STAssertNotNil([LFUser currentUser][@"sessionToken"], nil);
        
        // check login
        [LFUser logInWithUsernameInBackground:user.username password:user.password block:^(LFUser *loggedUser, NSError *error) {
            STAssertNil(error, nil);
            STAssertNotNil([LFUser currentUser], nil);
            STAssertNotNil([LFUser currentUser][@"sessionToken"], nil);
            STAssertEquals([LFUser currentUser][@"sessionToken"], loggedUser[@"sessionToken"], nil);
            
            END_TEST;
        }];
    }];
    
    WAIT_TEST;
}

@end
