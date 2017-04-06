//
//  LINSubTagCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/8.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSubTagCell.h"
#import "LINSubTagItem.h"
#import <UIImageView+WebCache.h>

@interface LINSubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;


@end

@implementation LINSubTagCell

#pragma mark - 设置cell的frame时，留1点作为分割线
- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    
    // 才是真正给cell赋值
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 清空tableView分割线内边距，清空cell的约束边缘(iOS7之后才有)
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 封装设置cell的数据
- (void)setItem:(LINSubTagItem *)item {
    _item = item;
    
    // 设置cell的内容
    self.nameLbl.text = item.theme_name;
    
    // 如果人数大于10000，显示多少万人
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", item.sub_number];
    NSInteger num = [item.sub_number integerValue];
    if (num >= 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.numLbl.text = numStr;
    
    // 裁剪图片
    self.iconImgView.layer.cornerRadius = 30;
    self.iconImgView.layer.masksToBounds = YES;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.image_list]];
}

@end
