//
//  RensouTest.m
//  rensou
//
//  Created by u1 on 2013/09/08.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <GHUnit.h>
#import "Rensou.h"

@interface Rensou(Private)
+ (NSString *)formatDateString:(NSString *)string;
@end

@interface RensouTest : GHTestCase

@end

@implementation RensouTest

- (void)testFormatDateString
{
    GHAssertEqualStrings([Rensou formatDateString:@"2013-09-08T16:45:21+09:00"],
                         @"2013/09/08 16:45",
                         @"日付の形式を正常に変換する");
}


@end
