//
//  SpamManager.m
//  rensou
//
//  Created by u1 on 2013/08/11.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "SpamManager.h"

@interface SpamManager()

@property (strong, nonatomic) NSMutableSet *spamRensouIdSet;

@end


@implementation SpamManager

static SpamManager *_sharedInstance = nil;

+ (SpamManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SpamManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.spamRensouIdSet = [NSMutableSet set];
    }
    return self;
}

// 指定したidの連想を通報する
- (void)spamRensou:(int)rensouId
{
    NSLog(@"%s", __func__);
    [self.spamRensouIdSet addObject:[NSString stringWithFormat:@"%d", rensouId]];
    
    for (NSString *key in [self.spamRensouIdSet allObjects]) {
        NSLog(@"key = %@", key);
    }
    
    // 既読状態をディスクに保存
    [self save];
}

// 指定したidの連想への通報を解除する
- (void)unspamRensou:(int)rensouId
{
    [self.spamRensouIdSet removeObject:[NSString stringWithFormat:@"%d", rensouId]];
    
    // 既読状態をディスクに保存
    [self save];
}

// 指定したidが通報済みか
- (BOOL)isSpamed:(int)rensouId
{
    return [self.spamRensouIdSet containsObject:[NSString stringWithFormat:@"%d", rensouId]];
}


#pragma mark - データ永続化

- (void)save
{
    NSString *path = [SpamManager getFilePath];
    [NSKeyedArchiver archiveRootObject:self.spamRensouIdSet toFile:path];
}

- (void)load
{
    NSString *path = [SpamManager getFilePath];
    self.spamRensouIdSet = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (self.spamRensouIdSet == nil) {
        self.spamRensouIdSet = [NSMutableSet set];
    }
}

+ (NSString *)getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:@"SpamManager.dat"];
}

@end
