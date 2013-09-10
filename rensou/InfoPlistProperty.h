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
 * rensou-Info.plist のプロパティ設定項目名
 */
@interface InfoPlistProperty : NSObject

/// APIリクエストを送る先のホスト名
extern NSString * const kServerHostName;

/// アプリのバージョン番号
extern NSString * const kBundleVersion;

/// 問い合わせ先メールアドレス
extern NSString * const kSupportEmailAddress;

/// Nend ID
extern NSString * const kNendId;

/// Nend Spot ID
extern NSString * const kNendSpotId;

/// Flurry API Key
extern NSString * const kFlurryApiKey;

/// Crashlytics API Key
extern NSString * const kCrashlyticsApiKey;

@end
