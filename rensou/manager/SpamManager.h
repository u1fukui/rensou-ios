//
//  SpamManager.h
//  rensou
//
//  Created by u1 on 2013/08/11.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpamManager : NSObject

+ (SpamManager *)sharedManager;

// 指定したidの連想を通報する
- (void)spamRensou:(int)rensouId;

// 指定したidの連想への通報を解除する
- (void)unspamRensou:(int)rensouId;

// 指定したidの通知を通報した状態か？
- (BOOL)isSpamed:(int)rensouId;

// 読み込み
- (void)load;

@end
