//
//  LINUserCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/29.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINUserCell.h"
#import "LINUser.h"
#import <UIImageView+WebCache.h>

@interface LINUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;


@end

@implementation LINUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(LINUser *)user {
    _user = user;
    
    // 设置cell的内容
    self.screenNameLabel.text = user.screen_name;
    
    // 如果人数大于10000，显示多少万人
    NSString *fansCountStr = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    if (user.fans_count >= 10000) {
        fansCountStr = [NSString stringWithFormat:@"%.1f万人关注", user.fans_count / 10000.0];
        fansCountStr = [fansCountStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.fansCountLabel.text = fansCountStr;
    
    // 裁剪图片
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header]];

    
}

@end
