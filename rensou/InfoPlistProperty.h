//
//  InfoPlistProperty.h
//  rensou
//
//  Created by u1 on 2013/06/09.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoPlistProperty : NSObject

// rensou-Info.plist のプロパティ設定項目名

extern NSString * const kServerHostName;
extern NSString * const kBundleVersion;
extern NSString * const kSupportEmailAddress;
extern NSString * const kNendId;
extern NSString * const kNendSpotId;
extern NSString * const kFlurryApiKey;
extern NSString * const kCrashlyticsApiKey;

@end
