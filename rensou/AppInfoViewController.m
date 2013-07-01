//
//  AppInfoViewController.m
//  rensou
//
//  Created by u1 on 2013/06/30.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppInfoViewController.h"
#import "LicenseViewController.h"

// lib
#import "GADBannerView.h"

// util
#import "UIColor+Hex.h"

// other
#import "InfoPlistProperty.h"


@interface AppInfoViewController ()

// 戻るボタン
@property (strong, nonatomic) UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *licenseButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

// 広告
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) GADBannerView *bannerView;

@end

@implementation AppInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ナビゲーションバー
    [self showNavigationBar];
    
    // 戻る
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_back"]
                               forState:UIControlStateNormal];
    [self.backButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // 背景
    self.view.backgroundColor = [UIColor colorWithHex:@"#A6E39D"];
    
    // ボタン
    [self.licenseButton addTarget:self
                           action:@selector(onClickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    // 広告
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = [[[NSBundle mainBundle] infoDictionary] objectForKey:kGadPublisherId];
    self.bannerView.rootViewController = self;
    [self.adView addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)showNavigationBar
{
    // ナビゲーションバー
    UIImage *navImage = [UIImage imageNamed:@"navigation_bg_info"];
    [self.navigationController.navigationBar setBackgroundImage:navImage
                                                  forBarMetrics:UIBarMetricsDefault];
    // 影を消す
    UIImage *shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}


#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    if (button == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (button == self.licenseButton) {
        LicenseViewController *controller = [[LicenseViewController alloc] initWithNibName:@"LicenseViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];

    } else if (button == self.mailButton) {
        // メール件名
        NSString *subject = [@"連想げーむお問い合わせ"
                             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // メーラー起動
        [[UIApplication sharedApplication] openURL:
        [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?Subject=%@",
          [[[NSBundle mainBundle] infoDictionary] objectForKey:kSupportEmailAddress], subject]]];
    }
}

@end
