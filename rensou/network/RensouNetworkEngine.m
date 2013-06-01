//
//  RensouNetworkEngine.m
//  rensou
//
//  Created by u1 on 2013/03/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "RensouNetworkEngine.h"

@implementation RensouNetworkEngine

#define kHostName @"localhost:4567"

// 連想リストの取得
-(MKNetworkOperation*) getRensouList:(int) count
                   completionHandler:(ResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensous.json"
                                              params:nil
                                          httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         completionBlock(completedOperation);
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
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
    NSLog(@"int = %d", themeId);
    NSLog(@"number = %@", [NSNumber numberWithInteger:themeId]);
    NSLog(@"str = %@", [NSString stringWithFormat:@"%d", themeId]);
    
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
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         completionBlock(completedOperation);
         // completionBlock([self jsonToSpotArray:[completedOperation responseString]]);
     
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
     
         errorBlock(error);
     
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
