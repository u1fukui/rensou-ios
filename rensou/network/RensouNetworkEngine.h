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

/**
 * サーバとの通信処理を実行する
 */
@interface RensouNetworkEngine : MKNetworkEngine

typedef void (^ResponseBlock)(MKNetworkOperation *op);

/**
 * シングルトンインスタンスの取得
 * @return シングルトンインスタンス
 */
+ (RensouNetworkEngine *)sharedEngine;


/**
 * ユーザIDの登録
 *
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) registerUserId:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想リストの取得
 *
 * @param count 取得する連想の数
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) getThemeRensou:(int) count
                    completionHandler:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想ワードの投稿
 *
 * @param rensouWord 投稿する連想ワード
 * @param themeId お題となった連想のID
 * @param userId 投稿するユーザのID
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) postRensou:(NSString *) rensouWord
                          themeId:(int) themeId
                           userId:(NSString *) userId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想に対していいね！
 *
 * @param rensouId いいね！する連想のID
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) likeRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想に対していいね！を取り消す
 *
 * @param rensouId いいね！を取り消す連想のID
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) unlikeRensou:(int) rensouId
                  completionHandler:(ResponseBlock) completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想を通報する
 *
 * @param rensouId 通報する連想のID
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) spamRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;


/**
 * 連想ランキングを取得
 *
 * @param completionBlock 通信成功時に実行するブロック
 * @param errorBlock 通信失敗時に実行するブロック
 * @return MKNetworkOperation
 */
-(MKNetworkOperation*) getRankingRensou:(ResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end
