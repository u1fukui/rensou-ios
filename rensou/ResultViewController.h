//
//  ResultViewController.h
//  rensou
//
//  Created by u1 on 2013/03/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (void)setResultRensouArray:(NSArray *)rensouArray;


@end
