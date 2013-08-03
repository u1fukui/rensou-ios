//
//  RankingCell.h
//  rensou
//
//  Created by u1 on 2013/08/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Rensou;

@interface RankingCell : UITableViewCell

- (void)setRensou:(Rensou *)rensou oldRensou:(Rensou *)oldRensou index:(int)index;
+ (CGFloat)cellHeight;

@end
