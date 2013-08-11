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
        _sharedInstance = [[RensouNetworkEngine alloc] initWithHostName:host];
    });
    return _sharedInstance;
}


#pragma mark - APIの実行

-(MKNetworkOperation*) registerUserId:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock
{
    // Body
    NSDictionary *params = @{
                             @"device_type": @"0",
                             };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"user"
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


// 連想リストの取得
-(MKNetworkOperation*) getThemeRensou:(int) count
                    completionHandler:(ResponseBlock) completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensou.json"
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
                           userId:(NSString *) userId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{    
    // Body
    NSDictionary *params = @{
                             @"keyword": rensouWord,
                             @"theme_id": [NSNumber numberWithInteger:themeId],
                             @"user_id": userId
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

// 連想に対していいね！
-(MKNetworkOperation*) likeRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"rensous/%d/like", rensouId]
                                              params:nil
                                          httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// 連想に対していいね！を取り消す
-(MKNetworkOperation*) unlikeRensou:(int) rensouId
                  completionHandler:(ResponseBlock) completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"rensous/%d/like", rensouId]
                                              params:nil
                                          httpMethod:@"DELETE"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// 連想に対して通報
-(MKNetworkOperation*) spamRensou:(int) rensouId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"rensous/%d/spam", rensouId]
                                              params:nil
                                          httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completionBlock(completedOperation);
         
     } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
         
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

// ランキングを取得
-(MKNetworkOperation*) getRankingRensou:(ResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock
{
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensous/ranking"
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

@end
