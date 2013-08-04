//
//  RensouCell.h
//  rensou
//
//  Created by u1 on 2013/06/01.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Rensou;

@interface RensouCell : UITableViewCell

@property (assign, nonatomic) BOOL isLiked;
@property (strong, nonatomic) UIButton *likeButton;

+ (CGFloat)cellHeight;
- (void)setRensou:(Rensou *)rensou index:(int)index;

- (void)likeRensou;
- (void)unlikeRensou;

@end
