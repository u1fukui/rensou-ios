//
//  Copyright (c) 2013 Yuichi Kobayashi
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source
//  distribution.
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
