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

#import "ResultViewController.h"
#import "RankingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RensouNetworkEngine.h"
#import "Rensou.h"
#import "RensouCell.h"
#import "SVProgressHUD.h"
#import "Flurry.h"
#import "UIColor+Hex.h"
#import "InfoPlistProperty.h"
#import "LikeManager.h"
#import "SpamManager.h"
#import "FlurryEventName.h"

const int kTagAlertSpam = 1;

@interface ResultViewController ()

@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (strong, nonatomic) NSMutableArray *rensouArray;

@property (strong, nonatomic) RensouCell *clickedCell;

// 広告
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) NADView *nadView;

// ランキングボタン
@property (strong, nonatomic) UIButton *rankingButton;

// 通信中か
@property (assign, nonatomic) BOOL isConnecting;

@end

@implementation ResultViewController


#pragma mark - コンストラクタ

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isConnecting = NO;
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
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0,0,
                                                             NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height )];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendId]
                     spotID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendSpotId]];
    [self.nadView setDelegate:self];
    [self.nadView load];
    [self.adView addSubview:self.nadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNavigationBar];
    
    // 広告
    [self.nadView resume];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 広告
    [self.nadView pause];
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

- (void)dealloc
{
    // 広告
    [self.nadView setDelegate:nil];
    self.nadView = nil;
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
        
        // いいね
        [cell.likeButton addTarget:self
                            action:@selector(onClickLikeButton:event:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        // 通報
        [cell.spamButton addTarget:self
                            action:@selector(onClickSpamButton:event:)
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

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.resultTableView];
    return [self.resultTableView indexPathForRowAtPoint:p];
}

// いいねボタンをタップ
- (void)onClickLikeButton:(UIButton *)button event:(UIEvent *)event
{
    // 通信中なら何もしない
    if (self.isConnecting) {
        return;
    }
    
    // Flurry
    [Flurry logEvent:kEventLike];
    
    // タップした連想を取得
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    Rensou *rensou = [self.rensouArray objectAtIndex:indexPath.row];
    RensouCell *cell = (RensouCell *)[self.resultTableView cellForRowAtIndexPath:indexPath];
    
    // いいね！済みかどうかで処理が変わる
    BOOL isLiked = [[LikeManager sharedManager] isLiked:rensou.rensouId];
    if (isLiked) {
        [self unlikeRensou:cell rensouId:rensou.rensouId];
    } else {
        [self likeRensou:cell rensouId:rensou.rensouId];
    }
    
    // アニメーション
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:2.0];
    
    // アニメーションを追加
    [cell.likeButton.layer addAnimation:animation forKey:@"scale-layer"];
}

// いいね！する
- (void)likeRensou:(RensouCell *)cell rensouId:(int)rensouId
{
    // 成功時
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        [[LikeManager sharedManager] likeRensou:rensouId];
        self.isConnecting = NO;
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        [cell unlikeRensou];
        self.isConnecting = NO;
    };
    
    [cell likeRensou];
    self.isConnecting = YES;
    [[RensouNetworkEngine sharedEngine] likeRensou:rensouId
                                    completionHandler:responseBlock
                                        errorHandler:errorBlock];
}

// いいね！を解除する
- (void)unlikeRensou:(RensouCell *)cell rensouId:(int)rensouId
{
    // 成功時
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        [[LikeManager sharedManager] unlikeRensou:rensouId];
        self.isConnecting = NO;
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        [cell likeRensou];
        self.isConnecting = NO;
    };
    
    [cell unlikeRensou];
    self.isConnecting = YES;
    [[RensouNetworkEngine sharedEngine] unlikeRensou:rensouId
                                   completionHandler:responseBlock
                                        errorHandler:errorBlock];
}

// 通報ボタンをタップ
- (void)onClickSpamButton:(UIButton *)button event:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    
    // 通信中なら何もしない
    if (self.isConnecting) {
        return;
    }
    
    // タップした連想を取得
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    self.clickedCell = (RensouCell *)[self.resultTableView cellForRowAtIndexPath:indexPath];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"この投稿を通報します。よろしいですか？"
                              delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    alert.tag = kTagAlertSpam;
    [alert show];
}

// 通報する
- (void)spamRensou:(RensouCell *)cell rensouId:(int)rensouId
{
    // 成功時
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"success");
        [[SpamManager sharedManager] spamRensou:rensouId];
        self.isConnecting = NO;
        [self.resultTableView reloadData];
        
        // Flurry
        [Flurry logEvent:kEventSpam];
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        NSLog(@"failed");
        self.isConnecting = NO;
    };
    
    self.isConnecting = YES;
    [[RensouNetworkEngine sharedEngine] spamRensou:rensouId
                                 completionHandler:responseBlock
                                      errorHandler:errorBlock];
}


#pragma mark -

- (void)requestGetRankingRensou
{
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // Flurry
        [Flurry logEvent:kEventRanking];
        
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


#pragma mark - UIAlerViewDelegate

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%s", __func__);
  
    // 通報
    if (alertView.tag == kTagAlertSpam) {
        
        // OK
        if (buttonIndex == 1) {
            NSIndexPath *indexPath = [self.resultTableView indexPathForCell:self.clickedCell];
            Rensou *rensou = [self.rensouArray objectAtIndex:indexPath.row];
            [self spamRensou:self.clickedCell rensouId:rensou.rensouId];
        }
    }
}


#pragma mark - Public Method

- (void)setResultRensouArray:(NSMutableArray *)rensouArray
{
    self.rensouArray = rensouArray;
    [self.resultTableView reloadData];
}


@end
