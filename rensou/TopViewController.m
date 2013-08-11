//
//  TopViewController.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "TopViewController.h"
#import "ResultViewController.h"
#import "AppInfoViewController.h"

// lib
#import "SVProgressHUD.h"

// net
#import "RensouNetworkEngine.h"
#import "Rensou.h"

// util
#import "UIColor+Hex.h"
#import "NSString+Validation.h"

// other
#import "AppDelegate.h"
#import "RSNotification.h"
#import "InfoPlistProperty.h"

@interface TopViewController()

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *subTextImageView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

// テーマとなる連想
@property (strong, nonatomic) Rensou *themeRensou;

// 広告
@property (strong, nonatomic) NADView *nadView;

// アプリ情報アイコン
@property (strong, nonatomic) UIButton *infoButton;

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
    
    // ナビゲーションバー
    [self showNavigationBar];

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
    [self.submitButton setImage:buttonImage forState:UIControlStateNormal];
    [self.submitButton setImage:buttonImage forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self
                          action:@selector(onClickButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
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
    [self showNavigationBar];
    [self requestGetThemeRensou];
    
    // 広告
    [self.nadView resume];
    
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
    [super viewDidDisappear:animated];
    
    // NotificationCenterの削除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 広告
    [self.nadView pause];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setThemeLabel:nil];
    [self setInputTextField:nil];
    [self setSubmitButton:nil];
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
    // 絵文字は不可
    if ([NSString isEmoji:string]) {
        return NO;
    }
    
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
    
}


#pragma mark - 通信

- (void)requestGetThemeRensou
{
    NSLog(@"%s", __func__);
    
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        self.themeRensou = [[Rensou alloc] initWithDictionary:op.responseJSON];
        self.themeLabel.text = self.themeRensou.keyword;
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // エラーメッセージ表示
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"通信が失敗しました。電波の良い所でも失敗するようでしたら、アプリ情報画面からご連絡お願いします。"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    };
    
    // インジケータ表示
    [SVProgressHUD show];
    
    // 通信実行
    [[RensouNetworkEngine sharedEngine] getThemeRensou:20
                                     completionHandler:responseBlock
                                          errorHandler:errorBlock];
}


- (void)requestPostRensou
{
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // レスポンスの解析
        NSMutableArray *rensouArray = [NSMutableArray array];
        NSArray *responseArray = op.responseJSON;
        for (NSDictionary *dict in responseArray) {
            [rensouArray addObject:[[Rensou alloc] initWithDictionary:dict]];
        }
        
        // 連想結果画面に遷移
        if (rensouArray.count > 0) {
            self.inputTextField.text = @"";
            
            ResultViewController *controller = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            [controller setResultRensouArray:rensouArray];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
        }
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // インジケータ終了
        [SVProgressHUD dismiss];
        
        // エラーメッセージ表示
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"エラー" message:@"投稿に失敗しました。テーマが更新されている可能性があります。"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        // 更新されている可能性が高いので入力リセット
        self.inputTextField.text = @"";
        
        // 取得
        [self requestGetThemeRensou];
        
        return;
    };
    
    // インジケータ表示
    [SVProgressHUD show];
    
    
    // 通信実行
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[RensouNetworkEngine sharedEngine] postRensou:self.inputTextField.text
                                           themeId:self.themeRensou.rensouId
                                            userId:appDelegate.userId
                                 completionHandler:responseBlock
                                      errorHandler:errorBlock];
}


#pragma mark - 通知

- (void)handleWillEnterForegroundNotification:(NSNotification *)notification
{
    // アプリ起動した時は、最新テーマを取得し直す
    [self requestGetThemeRensou];
}

#pragma mark - イベント

- (void)onClickButton:(UIButton *)button
{
    [self.inputTextField resignFirstResponder];
    
    if (button == self.infoButton) {
        AppInfoViewController *controller = [[AppInfoViewController alloc] initWithNibName:@"AppInfoViewController" bundle:nil];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    } else if (self.submitButton) {
        if ([NSString isBlank:self.inputTextField.text]) {
            // エラーメッセージ
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"エラー" message:@"連想される言葉を入力して下さい。"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            [self requestPostRensou];
        }
    }
}

@end
