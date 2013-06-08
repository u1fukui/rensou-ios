//
//  ResultViewController.m
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "ResultViewController.h"
#import "Rensou.h"
#import "RensouCell.h"
#import "UIColor+Hex.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property NSArray *rensouArray;

@end

@implementation ResultViewController


#pragma mark - コンストラクタ

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Navigation
    self.navigationItem.title = @"連想履歴";
    
    // 背景
    self.view.backgroundColor = [UIColor colorWithHex:@"38CB7D"];
    
    // Table
    self.resultTableView.dataSource = self;
    self.resultTableView.delegate = self;
    self.resultTableView.backgroundColor = [UIColor clearColor];
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
    [cell setRensou:rensou oldRensou:oldRensou];
    
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


#pragma mark - Public Method

- (void)setResultRensouArray:(NSArray *)rensouArray
{
    self.rensouArray = rensouArray;
    [self.resultTableView reloadData];
}

@end
