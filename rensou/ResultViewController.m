//
//  ResultViewController.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "ResultViewController.h"
#import "AppInfoViewController.h"

// api
#import "Rensou.h"

// view
#import "RensouCell.h"

// lib
#import "GADBannerView.h"

// util
#import "UIColor+Hex.h"

// other
#import "InfoPlistProperty.h"


@interface ResultViewController ()

@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property NSArray *rensouArray;

// 広告
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) GADBannerView *bannerView;

// アプリ情報ボタン
@property (strong, nonatomic) UIButton *infoButton;


@end

@implementation ResultViewController


#pragma mark - コンストラクタ

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - UIViewController LifeCycle

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
    
    // アプリ情報
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"navigation_info"]
                               forState:UIControlStateNormal];
    [self.infoButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:self.infoButton];
    self.navigationItem.rightBarButtonItem = infoButton;
    
    
    // 背景
    self.view.backgroundColor = [UIColor colorWithHex:@"#A6E39D"];
    
    // Table
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    self.resultTableView.backgroundColor = [UIColor clearColor];
    
    // 広告
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = [[[NSBundle mainBundle] infoDictionary] objectForKey:kGadPublisherId];
    self.bannerView.rootViewController = self;
    [self.adView addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setResultTableView:nil];
    [super viewDidUnload];
}


#pragma mark -

- (void)showNavigationBar
{
    // ナビゲーションバー
    UIImage *navImage = [UIImage imageNamed:@"navigation_bg_result"];
    [self.navigationController.navigationBar setBackgroundImage:navImage
                                                  forBarMetrics:UIBarMetricsDefault];
    // 影を消す
    UIImage *shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rensouArray.count - 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    NSLog(@"indexPath.row = %d", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    RensouCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RensouCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
    }
    
    Rensou *rensou = [self.rensouArray objectAtIndex:indexPath.row];
    Rensou *oldRensou = [self.rensouArray objectAtIndex:indexPath.row + 1];
    [cell setRensou:rensou oldRensou:oldRensou index:indexPath.row];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RensouCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 何もしない
}


#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    if (button == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (button == self.infoButton) {
        AppInfoViewController *controller = [[AppInfoViewController alloc] initWithNibName:@"AppInfoViewController" bundle:nil];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}


#pragma mark - Public Method

- (void)setResultRensouArray:(NSArray *)rensouArray
{
    self.rensouArray = rensouArray;
    [self.resultTableView reloadData];
}

@end
