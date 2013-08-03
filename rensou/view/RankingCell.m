//
//  RankingCell.m
//  rensou
//
//  Created by u1 on 2013/08/03.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "RankingCell.h"
#import "Rensou.h"

@interface RankingCell()

@property UILabel *keywordLabel;
@property UILabel *createdTimeLabel;
@property UIImageView *rankingIconView;

@end

@implementation RankingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ranking_cell_bg"]];
        
        // キーワード
        self.keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f,
                                                                      40.0f,
                                                                      260.0f,
                                                                      50.0f)];
        self.keywordLabel.backgroundColor = [UIColor clearColor];
        self.keywordLabel.numberOfLines = 2;
        self.keywordLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.keywordLabel];
        
        // 投稿日時
        self.createdTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160.0f,
                                                                          95.0f,
                                                                          200.0f,
                                                                          20.0f)];
        self.createdTimeLabel.backgroundColor = [UIColor clearColor];
        self.createdTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.createdTimeLabel.textColor = [UIColor grayColor];
        [self addSubview:self.createdTimeLabel];
        
        // 王冠
        self.rankingIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank1_icon"]];
        CGRect frame = self.rankingIconView.frame;
        frame.origin = CGPointMake(14.0f, 14.0f);
        self.rankingIconView.frame = frame;
        [self addSubview:self.rankingIconView];
        
        // ハイライト無効
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 120.0f;
}

#pragma mark - Public Method

- (void)setRensou:(Rensou *)rensou oldRensou:(Rensou *)oldRensou index:(int)index
{
    [self setRensouKeyword:rensou.keyword oldKeyword:oldRensou.keyword];
    self.createdTimeLabel.text = rensou.createdAt;
    
    NSString *imageName = [NSString stringWithFormat:@"rank%d_icon", index + 1];
    self.rankingIconView.image = [UIImage imageNamed:imageName];
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
