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

@interface TopViewController()

@property (nonatomic, strong) ResultViewController *resultViewController;
@property (nonatomic, strong) RensouNetworkEngine *rensouNetworkEngine;

@property Rensou *themeRensou;

@end


@implementation TopViewController

#pragma mark UIViewController LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rensouNetworkEngine = [[RensouNetworkEngine alloc] initWithHostName:@"localhost:4567"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ナビゲーションバー
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"連想げーむ";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    
    // 背景
    self.view.backgroundColor = [UIColor colorWithHex:@"#38CB7D"];
    
    
    // 送信ボタン
#warning 見た目を変える
    //self.postingButton.enabled = NO;
    
    [self requestGetThemeRensou];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // キーボードイベント
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onUIKeyboardWillShowNotification:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onUIKeyboardDidShowNotification:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onUIKeyboardWillHideNotification:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onUIKeyboardDidHideNotification:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
    [self requestGetThemeRensou];
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
    int maxLength = 15;
	NSMutableString *text = [textField.text mutableCopy];
	[text replaceCharactersInRange:range withString:string];
	return [text length] <= maxLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -

- (IBAction)tapPostingButton:(id)sender
{
    [self.inputTextField resignFirstResponder];
    [self requestPostRensou];
}


#pragma mark - 通信

- (void)requestGetThemeRensou
{
    // レスポンスに対する処理
    ResponseBlock responseBlock = ^(MKNetworkOperation *op) {
        
        NSLog(@"response = %@", op.responseString);
        
        self.themeRensou = [[Rensou alloc] initWithDictionary:op.responseJSON];
        self.themeLabel.text = self.themeRensou.keyword;
    };
    
    // エラー処理
    MKNKErrorBlock errorBlock =  ^(NSError *error) {
        
        DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
        // エラーメッセージ表示
        //[AppDelegate showErrorMessage:[error localizedDescription]];
        return;
    };
    
    [self.rensouNetworkEngine getRensouList:20
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
    [_rensouNetworkEngine postRensou:self.inputTextField.text
                             themeId:self.themeRensou.rensouId
                   completionHandler:responseBlock
                        errorHandler:errorBlock];
}

@end
