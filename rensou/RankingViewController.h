//
//  RankingViewController.h
//  rensou
//
//  Created by u1 on 2013/08/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface RankingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NADViewDelegate>

- (void)setRankingRensouArray:(NSArray *)rensouArray;

@end
