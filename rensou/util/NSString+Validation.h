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
 * 文字列を検証する
 */
@interface NSString (Validation)

/**
 * 文字列が絵文字かを判定
 *
 * @param string 検証する文字列
 * @return 絵文字ならYES
 */
+ (BOOL)isEmoji:(NSString *)string;


/**
 * 文字列が空文字、もしくは空白かを判定
 *
 * @param string 検証する文字列
 * @return から文字、もしくは空白ならYES
 */
+ (BOOL)isBlank:(NSString *)string;

@end
