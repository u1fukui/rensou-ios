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
