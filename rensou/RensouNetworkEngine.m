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

-(MKNetworkOperation*) postRensou:(NSString*) rensouWord
                         latestId:(NSUInteger) latestId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock
{
    // Body
    NSDictionary *params = @{
                             @"keyword": rensouWord,
                             @"latest_id": [NSNumber numberWithInteger:latestId]
                            };
    
    // リクエスト
    MKNetworkOperation *op = [self operationWithPath:@"rensou"
                                              params:params
                                          httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         NSLog(@"response = %@", [completedOperation responseString]);
         // completionBlock([self jsonToSpotArray:[completedOperation responseString]]);
     
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
     
         errorBlock(error);
     
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
