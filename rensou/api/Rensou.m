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
        self.likeCount = [dict[@"favorite"] intValue];
        self.keyword = dict[@"keyword"];
        self.oldKeyword = dict[@"old_keyword"];
        
        self.createdAt = [Rensou formatDateString:dict[@"created_at"]];
    }
    return self;
}

// 日付の書式変換
+ (NSString *)formatDateString:(NSString *)string
{
    NSLog(@"%@", string);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    return [dateFormatter stringFromDate:date];
}


@end
