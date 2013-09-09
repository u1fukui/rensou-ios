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

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface RensouNetworkEngine : MKNetworkEngine

typedef void (^ResponseBlock)(MKNetworkOperation *op);

//シングルトンインスタンス取得
+ (RensouNetworkEngine *)sharedEngine;

// ユーザIDの登録
-(MKNetworkOperation*) registerUserId:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;

// 連想リストの取得
-(MKNetworkOperation*) getThemeRensou:(int) count
                    completionHandler:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;

// 連想ワードの投稿
-(MKNetworkOperation*) postRensou:(NSString *) rensouWord
                          themeId:(int) themeId
                           userId:(NSString *) userId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;

// 連想に対していいね！
-(MKNetworkOperation*) likeRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;

// 連想に対していいね！を取り消す
-(MKNetworkOperation*) unlikeRensou:(int) rensouId
                  completionHandler:(ResponseBlock) completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;

// 連想に対して通報
-(MKNetworkOperation*) spamRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;

// 連想リストの取得
-(MKNetworkOperation*) getRankingRensou:(ResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end
