//
//  RensouNetworkEngine.h
//  rensou
//
//  Created by u1 on 2013/03/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface RensouNetworkEngine : MKNetworkEngine

typedef void (^ResponseBlock)(MKNetworkOperation *op);

// シングルトンインスタンス取得
+ (RensouNetworkEngine *)sharedEngine;

// 連想リストの取得
-(MKNetworkOperation*) getThemeRensou:(int) count
                    completionHandler:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;

// 連想ワードの投稿
-(MKNetworkOperation*) postRensou:(NSString*) rensouWord
                          themeId:(int) themeId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;

@end
