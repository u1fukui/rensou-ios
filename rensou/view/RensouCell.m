//
//  RensouCell.m
//  rensou
//
//  Created by u1 on 2013/06/01.
//  Copyright (c) 2013年 u1. All rights reserved.
//

#import "RensouCell.h"
#import "Rensou.h"
#import "LikeManager.h"
#import "SpamManager.h"

@interface RensouCell()

@property UILabel *keywordLabel;
@property UILabel *createdTimeLabel;
@property UILabel *likeCountLabel;
@property Rensou *rensou;

@end

@implementation RensouCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 背景
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rensou_cell_bg"]];
        
        // キーワード
        self.keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f,
                                                                      10.0f,
                                                                      260.0f,
                                                                      50.0f)];
        self.keywordLabel.backgroundColor = [UIColor clearColor];
        self.keywordLabel.numberOfLines = 2;
        self.keywordLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.keywordLabel];
        
        // 投稿日時
        self.createdTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f,
                                                                          67.0f,
                                                                          150.0f,
                                                                          20.0f)];
        self.createdTimeLabel.backgroundColor = [UIColor clearColor];
        self.createdTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.createdTimeLabel.textColor = [UIColor grayColor];
        [self addSubview:self.createdTimeLabel];
        
        // スパムボタン
        self.spamButton = [[UIButton alloc] initWithFrame:CGRectMake(165.0f,
                                                                     60.0f,
                                                                     25.0f,
                                                                     30.0f)];
        [self.spamButton setImage:[UIImage imageNamed:@"button_spam_off"]
                         forState:UIControlStateNormal];
        [self addSubview:self.spamButton];
        
        // いいね！ボタン
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(200.0f,
                                                                    60.0f,
                                                                    50.0f,
                                                                    30.0f)];
        [self.likeButton setImage:[UIImage imageNamed:@"button_like_off"]
                         forState:UIControlStateNormal];
        [self addSubview:self.likeButton];
        
        // いいね数
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0f,
                                                                        65.0f,
                                                                        60.0f,
                                                                        20.0f)];
        self.likeCountLabel.backgroundColor = [UIColor clearColor];
        self.likeCountLabel.font = [UIFont systemFontOfSize:12.0f];
        self.likeCountLabel.textColor = [UIColor blackColor];
        [self addSubview:self.likeCountLabel];
        
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
    return 100.0f;
}

#pragma mark - Public Method

- (void)setRensou:(Rensou *)rensou index:(int)index
{
    self.rensou = rensou;
    self.createdTimeLabel.text = rensou.createdAt;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", self.rensou.likeCount];
    
    //
    BOOL isSpamed = [[SpamManager sharedManager] isSpamed:rensou.rensouId];
    if (isSpamed) {
        self.keywordLabel.text = @"この投稿は通報済みです。";
        
        // 非表示
        self.likeButton.hidden = YES;
        self.likeCountLabel.hidden = YES;
        self.spamButton.hidden = YES;
    } else {
        // 表示
        self.likeButton.hidden = NO;
        self.likeCountLabel.hidden = NO;
        self.spamButton.hidden = NO;
        
        // キーワード
        [self setRensouKeyword:rensou.keyword oldKeyword:rensou.oldKeyword];
        
        // いいねボタン
        BOOL isLiked = [[LikeManager sharedManager] isLiked:rensou.rensouId];
        if (isLiked) {
            [self.likeButton setImage:[UIImage imageNamed:@"button_like_on"]
                             forState:UIControlStateNormal];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"button_like_off"]
                             forState:UIControlStateNormal];
        }
    }
    
    // 交互に枠の向きを変える
    if (index % 2 == 0) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rensou_cell_bg"]];
        
        CGRect frame = self.keywordLabel.frame;
        frame.origin.x = 30.0f;
        self.keywordLabel.frame = frame;
        
        
    } else {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rensou_cell_bg2"]];
        
        CGRect frame = self.keywordLabel.frame;
        frame.origin.x = 40.0f;
        self.keywordLabel.frame = frame;
        
        frame = self.createdTimeLabel.frame;
        frame.origin.x = 40.0f;
        self.createdTimeLabel.frame = frame;
    }
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

- (void)likeRensou
{
    self.isLiked = YES;
    [self.likeButton setImage:[UIImage imageNamed:@"button_like_on"]
                     forState:UIControlStateNormal];
    
    self.rensou.likeCount++;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", self.rensou.likeCount];
}

- (void)unlikeRensou
{
    self.isLiked = NO;
    [self.likeButton setImage:[UIImage imageNamed:@"button_like_off"]
                     forState:UIControlStateNormal];
    
    self.rensou.likeCount--;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d", self.rensou.likeCount];
}

@end
