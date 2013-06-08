//
//  RensouCell.m
//  rensou
//
//  Created by u1 on 2013/06/01.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "RensouCell.h"
#import "Rensou.h"

@interface RensouCell()

@property UILabel *keywordLabel;
@property UILabel *createdTimeLabel;

@end

@implementation RensouCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景
        self.backgroundColor = [UIColor clearColor];
        
        // キーワード
        self.keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                                      10.0f,
                                                                      280.0f,
                                                                      50.0f)];
        self.keywordLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.keywordLabel];
        
        // 投稿日時
        self.createdTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0f,
                                                                          50.0f,
                                                                          200.0f,
                                                                          20.0f)];
        self.createdTimeLabel.backgroundColor = [UIColor clearColor];
        self.createdTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.createdTimeLabel.textColor = [UIColor grayColor];
        [self addSubview:self.createdTimeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Class Method

+ (CGFloat)cellHeight
{
    return 70.0f;
}

#pragma mark - Public Method

- (void)setRensou:(Rensou *)rensou oldRensou:(Rensou *)oldRensou
{
    [self setRensouKeyword:rensou.keyword oldKeyword:oldRensou.keyword];
    self.createdTimeLabel.text = rensou.createdAt;
}

#pragma mark - 表示内容の設定

- (void)setRensouKeyword:(NSString *)keyword oldKeyword:(NSString *)oldKeyword
{
    // 古いキーワード
    NSAttributedString *old =
    [[NSAttributedString alloc] initWithString:oldKeyword
                                    attributes:@{ NSForegroundColorAttributeName: [UIColor redColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]}];
    // つなぎ
    NSAttributedString *and =
    [[NSAttributedString alloc] initWithString:@" といえば "
                                    attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
    // 新しいキーワード
    NSAttributedString *new =
    [[NSAttributedString alloc] initWithString:keyword
                                    attributes:@{ NSForegroundColorAttributeName: [UIColor redColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f]}];
    // 連結
    NSMutableAttributedString *mainText = [[NSMutableAttributedString alloc] initWithAttributedString:old];
    [mainText appendAttributedString:and];
    [mainText appendAttributedString:new];
    self.keywordLabel.attributedText = mainText;
}

@end
