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
 * FlurryAnalyticsで使用するイベント名
 */
@interface FlurryEventName : NSObject

/// アプリ起動
extern NSString * const kEventLaunchApp;

/// アプリアクティブ
extern NSString * const kEventActiveApp;

/// 連想ワードの投稿
extern NSString * const kEventPost;

/// 連想の通報
extern NSString * const kEventSpam;

/// 連想のいいね！
extern NSString * const kEventLike;

/// 連想ランキング画面を表示
extern NSString * const kEventRanking;

/// アプリ情報画面を表示
extern NSString * const kEventInfo;

@end
