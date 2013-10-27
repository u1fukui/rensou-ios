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

#import "AppDelegate.h"
#import "RSNotification.h"
#import "LikeManager.h"
#import "SpamManager.h"
#import "RensouNetworkEngine.h"
#import "InfoPlistProperty.h"

// lib
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "FlurryEventName.h"
#import "SVProgressHUD.h"

const int kTagAlertError = 1;
const int kTagAlertEula = 2;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[TopViewController alloc] initWithNibName:@"TopViewController" bundle:nil];
    self.rootController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];
    
    // Flurry
    [Flurry setSecureTransportEnabled:YES];
    
    NSString *flurryKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:kFlurryApiKey];
    if (flurryKey.length > 0) {
        [Flurry startSession:flurryKey];
    }
    [Flurry logEvent:kEventLaunchApp];
    
    // Crashlytics
    NSString *crashlyticsKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:kCrashlyticsApiKey];
    if (crashlyticsKey.length > 0) {
        [Crashlytics startWithAPIKey:crashlyticsKey];
    }
    
    // ユーザ管理
    [self load];
    if (self.userId == nil) {
        NSString *message = @"サービスを利用するには以下の内容に同意下さい。\n\n1. 禁止事項\n・個人情報や他の方が不快と感じるような内容は投稿しないで下さい\n\n2. 表示内容について\n・不快と感じる投稿が表示される可能性があります\n・不快な投稿があった場合は通報ボタンを押して下さい";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認" message:message
                                                       delegate:self cancelButtonTitle:@"同意する" otherButtonTitles:nil];
        alert.tag = kTagAlertEula;
        
        // ios7では効かない…。
        for( NSObject *obj in [alert subviews] ) {
            if( [obj isKindOfClass:[UILabel class]] ) {
                ((UILabel *)obj).textAlignment = NSTextAlignmentLeft;
            }
        }
        
        [alert show];
    } else {
        // いいね管理を読み込み
        [[LikeManager sharedManager] load];
        [[SpamManager sharedManager] load];
    }
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
    
    // Flurry
    NSString *message = [NSString stringWithFormat:@"%@", [exception callStackSymbols]];
    [Flurry logError:@"Uncaught" message:message exception:exception];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 通知
    NSNotification *n = [NSNotification notificationWithName:RSWillEnterForegroundNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Flurry
    [Flurry logEvent:kEventActiveApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - ユーザ登録

- (void)requestRegisterUser
{
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        // ダイアログ非表示
        [SVProgressHUD dismiss];

        NSDictionary *dict = op.responseJSON;
        
        // ユーザ情報設定
        self.userId = dict[@"user_id"];
        [self save];
        
        // PUSH通知登録
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        // ダイアログ非表示
        [SVProgressHUD dismiss];
        
        // ユーザIDが設定されるまで繰り返す
        if (self.userId == nil) {
            // エラーメッセージ
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"エラー" message:@"通信に失敗しました。電波の良いところで再度試してみて下さい。"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kTagAlertError;
            [alert show];
        }
    };
    
    // ダイアログ非表示
    [SVProgressHUD show];
    
    // 通信
    [[RensouNetworkEngine sharedEngine] registerUserId:responseBlock
                                          errorHandler:errorBlock];
}


#pragma mark - データ永続化

- (void)save
{
    NSString *path = [AppDelegate getFilePath];
    [NSKeyedArchiver archiveRootObject:self.userId toFile:path];
}

- (void)load
{
    NSString *path = [AppDelegate getFilePath];
    self.userId = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (NSString *)getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:@"UserId.dat"];
}


#pragma mark - UIAlerViewDelegate

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%s", __func__);
    
    switch (alertView.tag) {
        case kTagAlertError:
            [self requestRegisterUser];
            break;
        case kTagAlertEula:
            [self requestRegisterUser];
            break;
    }
}


@end
