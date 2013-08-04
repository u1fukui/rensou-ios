//
//  LikeManager.m
//  rensou
//
//  Created by u1 on 2013/08/04.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "LikeManager.h"

@interface LikeManager()

@property (strong, nonatomic) NSMutableSet *likeRensouIdSet;

@end


@implementation LikeManager

static LikeManager *_sharedInstance = nil;

+ (LikeManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LikeManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.likeRensouIdSet = [NSMutableSet set];
    }
    return self;
}

// 指定したidの連想をいいね！する
- (void)likeRensou:(int)rensouId
{
    NSLog(@"%s", __func__);
    [self.likeRensouIdSet addObject:[NSString stringWithFormat:@"%d", rensouId]];
    
    for (NSString *key in [self.likeRensouIdSet allObjects]) {
        NSLog(@"key = %@", key);
    }
    
    // 既読状態をディスクに保存
    [self save];
}
     
// 指定したidの連想へのいいね！を解除する
- (void)unlikeRensou:(int)rensouId
{
    [self.likeRensouIdSet removeObject:[NSString stringWithFormat:@"%d", rensouId]];
    
    // 既読状態をディスクに保存
    [self save];
}
         
// 指定したidがいいね！済みか
- (BOOL)isLiked:(int)rensouId
{
    return [self.likeRensouIdSet containsObject:[NSString stringWithFormat:@"%d", rensouId]];
}


#pragma mark - データ永続化

- (void)save
{
    NSString *path = [LikeManager getFilePath];
    [NSKeyedArchiver archiveRootObject:self.likeRensouIdSet toFile:path];
}

- (void)load
{
    NSString *path = [LikeManager getFilePath];
    self.likeRensouIdSet = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (self.likeRensouIdSet == nil) {
        self.likeRensouIdSet = [NSMutableSet set];
    }
}

+ (NSString *)getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:@"LikeManager.dat"];
}

@end
