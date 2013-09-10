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

/**
 * どの連想に対していいね！したかを管理する
 */
@interface LikeManager : NSObject

/**
 * シングルトンインスタンスを取得
 *
 * @return シングルトンインスタンス
 */
+ (LikeManager *)sharedManager;


/**
 * 指定したidの連想をいいね！する
 *
 * @param rensouId 連想ID
 */
- (void)likeRensou:(int)rensouId;


/**
 * 指定したidの連想へのいいね！を解除する
 *
 * @param rensouId 連想ID
 */
- (void)unlikeRensou:(int)rensouId;


/**
 * 指定したidの連想がいいね！済みかを取得
 *
 * @param rensouId 連想Id
 * @return いいね！済みならYES
 */
- (BOOL)isLiked:(int)rensouId;


/**
 *  ディスクに保存したいいね！管理情報を読み込む
 */
- (void)load;

@end
