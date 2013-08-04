//
//  LikeManager.h
//  rensou
//
//  Created by u1 on 2013/08/04.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeManager : NSObject

+ (LikeManager *)sharedManager;

// 指定したidの連想をいいね！する
- (void)likeRensou:(int)rensouId;

// 指定したidの連想へのいいね！を解除する
- (void)unlikeRensou:(int)rensouId;

// 指定したidの通知が既読状態か？
- (BOOL)isLiked:(int)rensouId;

// 読み込み
- (void)load;

@end
