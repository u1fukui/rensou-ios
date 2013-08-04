//
//  Rensou.h
//  rensou
//
//  Created by u1 on 2013/05/27.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rensou : NSObject

@property int rensouId;
@property int likeCount;
@property NSString *keyword;
@property NSString *oldKeyword;
@property NSString *createdAt;

- (id)initWithDictionary:(NSDictionary *) dict;

@end
