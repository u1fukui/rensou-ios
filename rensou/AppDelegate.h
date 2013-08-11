//
//  AppDelegate.h
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController* rootController;
@property (strong, nonatomic) TopViewController *viewController;

@property (strong, nonatomic) NSString *userId;

@end
