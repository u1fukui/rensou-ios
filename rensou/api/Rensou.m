//
//  Rensou.m
//  rensou
//
//  Created by u1 on 2013/05/27.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "Rensou.h"

@implementation Rensou

- (id)initWithDictionary:(NSDictionary *) dict
{
    self = [super init];
    if (self) {
        self.rensouId = [dict[@"id"] intValue];
        self.keyword = dict[@"keyword"];
        self.createdAt = dict[@"created_at"];
    }
    return self;
}

@end
