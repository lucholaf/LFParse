//
//  LFACL.m
//  LFParse
//
//  Created by lucho on 9/12/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import "LFACL.h"

@implementation LFACL

+ (LFACL *)ACLWithUser:(LFUser *)user
{
    LFACL *acl = [[LFACL alloc] initWithUser:user];
    return acl;
}

- (id)init
{
    self = [super init];
    if (self) {
        _acls = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithUser:(LFUser *)user
{
    self = [self init];
    if (self) {
        [self setReadAccess:YES forUserId:user.objectId];
        [self setWriteAccess:YES forUserId:user.objectId];
    }
    return self;
}

- (NSDictionary *)dictRepresentation
{
    return _acls;
}

- (void)makeSureDictExistForUserId:(NSString *)userId
{
    NSMutableDictionary *dict = _acls[userId];
    if (!dict)
    {
        dict = [NSMutableDictionary dictionary];
        _acls[userId] = dict;
    }
}

- (void)setReadAccess:(BOOL)allowed forUserId:(NSString *)userId
{
    [self makeSureDictExistForUserId:userId];
    
    _acls[userId][@"read"] = [NSNumber numberWithBool:allowed];
}

- (void)setWriteAccess:(BOOL)allowed forUserId:(NSString *)userId
{
    [self makeSureDictExistForUserId:userId];
    
    _acls[userId][@"write"] = [NSNumber numberWithBool:allowed];    
}


@end
