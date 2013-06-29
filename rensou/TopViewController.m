//
//  TopViewController.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "TopViewController.h"
#import "ResultViewController.h"
#import "RensouNetworkEngine.h"
#import "Rensou.h"
#import "UIColor+Hex.h"
#import "RSNotification.h"
#import "GADBannerView.h"
#import "InfoPlistProperty.h"

@interface TopViewController()

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *subTextImageView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (strong, nonatomic) ResultViewController *resultViewController;
@property (strong, nonatomic) Rensou *themeRensou;
@property (strong, nonatomic) NSDate *lastRequestDate;

// 広告
@property (strong, nonatomic) GADBannerView *bannerView;

@end


@implementation TopViewController

#pragma mark UIViewController LifeCycle

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
    // Do any additional setup after loading the view from its nib.
    
    // ナビゲーションバー
    [self showNavigationBar];

    // 背景
    self.view.backgroundColor = [UIColor colorWithHex:@"#A6E39D"];
    
    // 背景画像
    self.topBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg"]];
    
    // テーマ
    self.themeLabel.textColor = [UIColor colorWithHex:@"#C7243A"];
    self.themeLabel.numberOfLines = 3;
    self.themeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.subTextImageView.image = [UIImage imageNamed:@"sub_text"];
    
    self.inputTextField.backgroundColor = [UIColor whiteColor];
    
    // 送信ボタン
    UIImage *buttonImage = [UIImage imageNamed:@"button_submit"];
    [self.postingButton setImage:buttonImage forState:UIControlStateNormal];
    [self.postingButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    // 広告
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = [[[NSBundle mainBundle] infoDictionary] objectForKey:kGadPublisherId];
    self.bannerView.rootViewController = self;
    [self.adView addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    
    [super viewWillAppear:animated];
    [self showNavigationBar];
    [self requestGetThemeRensou];
    
    // キーボードイベント
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUIKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUIKeyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUIKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUIKeyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    // アプリ復帰時の通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillEnterForegroundNotification:)
                                                 name:RSWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // NotificationCenterの削除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setThemeLabel:nil];
    [self setThemeImageView:nil];
    [self setInputTextField:nil];
    [self setPostingButton:nil];
    [super viewDidUnload];
}


#pragma mark - 

- (void)showNavigationBar
{
    // ナビゲーションバー
    UIImage *navImage = [UIImage imageNamed:@"navigation_bg_top"];
    [self.navigationController.navigationBar setBackgroundImage:navImage
                                                  forBarMetrics:UIBarMetricsDefault];
    // 影を消す
    UIImage *shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:shadowImage];
}



#pragma mark - Keyboard show event

- (void)onUIKeyboardWillShowNotification:(NSNotification *)notification
{
    CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    CGPoint commentViewPoint = [TopViewController
                                absolutePointWithView:self.inputTextField];
    
    CGFloat bottom = commentViewPoint.y + self.inputTextField.frame.size.height
                                        + 10.0f;   // 10.0f はマージン
    
    CGFloat keyboardTop = mainBounds.size.height - keyboardBounds.size.height;
    
    [UIView animateWithDuration:0.3f
                     animations:^(void){
                         CGRect frame = self.view.frame;
                         frame.origin.y -= bottom - keyboardTop;
                         self.view.frame = frame;
                     }];
    
    
}

- (void)onUIKeyboardDidShowNotification:(NSNotification *)notification
{
}

- (void)onUIKeyboardWillHideNotification:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f
                     animations:^(void) {
                         CGRect frame = self.view.frame;
                         frame.origin.y = 0.0f;
                         self.view.frame = frame;
                     }];
}

- (void)onUIKeyboardDidHideNotification:(NSNotification *)notification
{
}

+ (CGPoint)absolutePointWithView:(UIView *)view
{
    CGPoint point = view.frame.origin;
    
    UIView *superView;
    
    while ((superView = view.superview)) {
        point.x += superView.frame.origin.x;
        point.y += superView.frame.origin.y;
        view = superView;
    }
    
    return point;
}


#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 最大文字数制限
    int maxLength = 13;
	NSMutableString *text = [textField.text mutableCopy];
	[text replaceCharactersInRange:range withString:string];
	return [text length] <= maxLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark - イベント

- (IBAction)tapPostingButton:(id)sender
{
    [self.inputTextField resignFirstResponder];
    [self requestPostRensou];
}


#pragma mark - 通信

- (void)requestGetThemeRensou
{
    NSLog(@"%s", __func__);
    
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        NSLog(@"responseBlock");
        NSLog(@"response = %@", op.responseString);
        
        self.lastRequestDate = [NSDate date];
        self.themeRensou = [[Rensou alloc] initWithDictionary:op.responseJSON];
        self.themeLabel.text = self.themeRensou.keyword;
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // エラーメッセージ表示
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"サーバが落ちている疑いがあります。ゆーいちまでご連絡ください。"
                                  delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
        
        return;
    };
    
    [[RensouNetworkEngine sharedEngine] getThemeRensou:20
                                     completionHandler:responseBlock
                                          errorHandler:errorBlock];
}


- (void)requestPostRensou
{
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        if (!self.resultViewController) {
            self.resultViewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            
            NSLog(@"self.resultViewController == %d", self.resultViewController == nil);
        }
        
        NSLog(@"%@", op.responseJSON);
        
        // レスポンスの解析
        NSMutableArray *rensouArray = [NSMutableArray array];
        NSArray *responseArray = op.responseJSON;
        for (NSDictionary *dict in responseArray) {
            [rensouArray addObject:[[Rensou alloc] initWithDictionary:dict]];
        }
        
        // 結果画面に遷移
        if (rensouArray.count > 0) {
            self.inputTextField.text = @"";
            [self.resultViewController setResultRensouArray:rensouArray];
            [self.navigationController pushViewController:self.resultViewController animated:YES];
        } else {
        }
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // エラーメッセージ表示
        //[AppDelegate showErrorMessage:[error localizedDescription]];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"投稿に失敗しました。"
                                  delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [alert show];
        
        return;
    };
    
    // 通信実行
    [[RensouNetworkEngine sharedEngine] postRensou:self.inputTextField.text
                                           themeId:self.themeRensou.rensouId
                                 completionHandler:responseBlock
                                      errorHandler:errorBlock];
}


#pragma mark - 通知

- (void)handleWillEnterForegroundNotification:(NSNotification *)notification
{
    // 前回取得時から一定時間経っていたら、最新テーマを取得し直す
    if ([[NSDate date] timeIntervalSinceDate:self.lastRequestDate] > 60.0f) {
        NSLog(@"interval > 60");
        [self requestGetThemeRensou];
    }
}

@end
