//
//  RensouNetworkEngine.m
//  rensou
//
//  Created by u1 on 2013/03/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "RensouNetworkEngine.h"
#import "InfoPlistProperty.h"

@implementation RensouNetworkEngine


#pragma mark - シングルトン

static RensouNetworkEngine *_sharedInstance = nil;

+ (RensouNetworkEngine *)sharedEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *host = [[[NSBundle mainBundle] infoDictionary] objectForKey:kServerHostName];
        NSLog(@"%s create engine: %@", __func__, host);
        _sharedInstance = [[RensouNetworkEngine alloc] initWithHostName:host];
    });
    return _sharedInstance;
}


#pragma mark - APIの実行

// 連想リストの取得
-(MKNetworkOperation*) getThemeRensou:(int) count
                    completionHandler:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensous.json"
                                              params:nil
                                          httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}


// 連想の登録
-(MKNetworkOperation*) postRensou:(NSString *) rensouWord
                          themeId:(int) themeId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{    
    // Body
    NSDictionary *params = @{
                             @"keyword": rensouWord,
                             @"theme_id": [NSNumber numberWithInteger:themeId]
                            };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensou.json"
                                              params:params
                                          httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
     
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
     
         errorBlock(error);
     
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
