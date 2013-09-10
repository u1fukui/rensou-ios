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

#import <UIKit/UIKit.h>

@class Rensou;

/**
 * 連想履歴を表示するCell
 */
@interface RensouCell : UITableViewCell

/// いいね！済みか
@property (assign, nonatomic) BOOL isLiked;

/// 通報済みか
@property (assign, nonatomic) BOOL isSpamed;

/// いいね！ボタン
@property (strong, nonatomic) UIButton *likeButton;

/// 通報ボタン
@property (strong, nonatomic) UIButton *spamButton;


/**
 * Cellの高さを取得
 * 
 * @return Cellの高さ
 */
+ (CGFloat)cellHeight;


/**
 * Cellに連想をセット
 * 
 * @param rensou 表示する連想
 * @param index UITableに対するこのCellの順番
 */
- (void)setRensou:(Rensou *)rensou index:(int)index;


/**
 * 連想に対していいね！
 */
- (void)likeRensou;


/**
 * 連想に対するいいね！を解除
 */
- (void)unlikeRensou;

@end
