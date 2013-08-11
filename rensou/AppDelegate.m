//
//  AppDelegate.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "AppDelegate.h"
#import "RSNotification.h"
#import "LikeManager.h"
#import "RensouNetworkEngine.h"
#import "SVProgressHUD.h"

const int kTagAlertError = 1;

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
    
    // ユーザ管理
    [self load];
    if (self.userId == nil) {
        [self requestRegisterUser];
    }
    
    // いいね管理を読み込み
    [[LikeManager sharedManager] load];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
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
        
        NSLog(@"response = %@", op.responseJSON);

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
    }
}


@end
