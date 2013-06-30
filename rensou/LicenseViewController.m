//
//  LicenseViewController.m
//  rensou
//
//  Created by u1 on 2013/06/30.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "LicenseViewController.h"

@interface LicenseViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIButton * backButton;

@end

@implementation LicenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    // 表示内容
    NSString *path = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    if (button == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
