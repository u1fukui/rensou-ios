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

#import "RankingViewController.h"
#import "InfoPlistProperty.h"
#import "RankingCell.h"
#import "UIColor+Hex.h"

@interface RankingViewController ()

@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *rankingTableView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property NSArray *rensouArray;

// 広告
@property (strong, nonatomic) NADView *nadView;

@end

@implementation RankingViewController

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
    
    // Table
    self.rankingTableView.dataSource = self;
    self.rankingTableView.delegate = self;
    self.rankingTableView.backgroundColor = [UIColor clearColor];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
    
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
    UIImage *navImage = [UIImage imageNamed:@"navigation_bg_ranking"];
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
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RankingCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
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
    return [RankingCell cellHeight];
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
    }
}


#pragma mark - Public Method

- (void)setRankingRensouArray:(NSArray *)rensouArray
{
    self.rensouArray = rensouArray;
    [self.rankingTableView reloadData];
}


@end
