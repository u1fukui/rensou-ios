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
