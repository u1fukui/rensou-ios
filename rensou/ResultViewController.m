//
//  ResultViewController.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "ResultViewController.h"
#import "RankingViewController.h"

// api
#import "RensouNetworkEngine.h"
#import "Rensou.h"

// view
#import "RensouCell.h"

// lib
#import "GADBannerView.h"
#import "SVProgressHUD.h"

// util
#import "UIColor+Hex.h"

// other
#import "InfoPlistProperty.h"
#import "LikeManager.h"

@interface ResultViewController ()

@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property NSArray *rensouArray;

// 広告
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) GADBannerView *bannerView;

// ランキングボタン
@property (strong, nonatomic) UIButton *rankingButton;


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
    self.rankingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rankingButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.rankingButton setBackgroundImage:[UIImage imageNamed:@"navigation_ranking"]
                               forState:UIControlStateNormal];
    [self.rankingButton addTarget:self
                           action:@selector(onClickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:self.rankingButton];
    self.navigationItem.rightBarButtonItem = button;
    
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
    return self.rensouArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RensouCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RensouCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
        
        [cell.likeButton addTarget:self
                            action:@selector(onClickLikeButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    Rensou *rensou = [self.rensouArray objectAtIndex:indexPath.row];
    [cell setRensou:rensou index:indexPath.row];
    
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
    } else if (button == self.rankingButton) {
        [self requestGetRankingRensou];
    }
}

- (void)onClickLikeButton:(UIButton *)button
{
    RensouCell *cell = (RensouCell *)[button superview];
    int row = [self.resultTableView indexPathForCell:cell].row;
    Rensou *rensou = [self.rensouArray objectAtIndex:row];
    
    // いいね！済みかどうかで処理が変わる
    BOOL isLiked = [[LikeManager sharedManager] isLiked:rensou.rensouId];
    if (isLiked) {
        [self unlikeRensou:cell rensouId:rensou.rensouId];
    } else {
        [self likeRensou:cell rensouId:rensou.rensouId];
    }
}

// いいね！する
- (void)likeRensou:(RensouCell *)cell rensouId:(int)rensouId
{
    // 成功時
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"response = %@", op.responseString);
        [[LikeManager sharedManager] likeRensou:rensouId];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        [cell unlikeRensou];
    };
    
    [cell likeRensou];
    [[RensouNetworkEngine sharedEngine] likeRensou:rensouId
                                    completionHandler:responseBlock
                                        errorHandler:errorBlock];
}

// いいね！を解除する
- (void)unlikeRensou:(RensouCell *)cell rensouId:(int)rensouId
{
    // 成功時
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"response = %@", op.responseString);
        [[LikeManager sharedManager] unlikeRensou:rensouId];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        [cell likeRensou];
    };
    
    [cell unlikeRensou];
    [[RensouNetworkEngine sharedEngine] unlikeRensou:rensouId
                                   completionHandler:responseBlock
                                        errorHandler:errorBlock];
}

#pragma mark - Public Method

- (void)setResultRensouArray:(NSArray *)rensouArray
{
    self.rensouArray = rensouArray;
    [self.resultTableView reloadData];
}


#pragma mark - 

- (void)requestGetRankingRensou
{
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"response = %@", op.responseString);
        
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // レスポンス解析
        NSMutableArray *rensouArray = [NSMutableArray array];
        NSArray *responseArray = op.responseJSON;
        for (NSDictionary *dict in responseArray) {
            [rensouArray addObject:[[Rensou alloc] initWithDictionary:dict]];
        }
        
        // 画面遷移
        RankingViewController *controller = [[RankingViewController alloc] initWithNibName:@"RankingViewController" bundle:nil];
        [controller setRankingRensouArray:rensouArray];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // エラーメッセージ表示
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"通信に失敗しました。"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    };
    
    // インジケータ表示
    [SVProgressHUD show];
    
    // 通信実行
    [[RensouNetworkEngine sharedEngine] getRankingRensou:responseBlock
                                            errorHandler:errorBlock];
}


@end
