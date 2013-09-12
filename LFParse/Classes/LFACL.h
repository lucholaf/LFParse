//
//  LFACL.h
//  LFParse
//
//  Created by lucho on 9/12/13.
//  Copyright (c) 2013 lucho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFUser.h"

@interface LFACL : NSObject
{
    NSMutableDictionary *_acls;
}

+ (LFACL *)ACLWithUser:(LFUser *)user;

- (void)setReadAccess:(BOOL)allowed forUserId:(NSString *)userId;
- (void)setWriteAccess:(BOOL)allowed forUserId:(NSString *)userId;

- (NSDictionary *)dictRepresentation;

@end
