//
//  RensouNetworkEngine.h
//  rensou
//
//  Created by u1 on 2013/03/20.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface RensouNetworkEngine : MKNetworkEngine

typedef void (^ResponseBlock)(NSArray *rensouArray);

-(MKNetworkOperation*) postRensou:(NSString*) rensouWord
                         latestId:(NSUInteger) latestId
                completionHandler:(ResponseBlock) completionBlock
                     errorHandler:(MKNKErrorBlock) errorBlock;

@end
