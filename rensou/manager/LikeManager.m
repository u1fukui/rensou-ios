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
