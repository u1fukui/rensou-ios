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

@end
