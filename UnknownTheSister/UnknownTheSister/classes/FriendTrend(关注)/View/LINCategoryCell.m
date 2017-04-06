//
//  LINCategoryCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/29.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINCategoryCell.h"
#import "LINCategory.h"

@interface LINCategoryCell ()

// 左边的选中指示器
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end

@implementation LINCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 清除文字背景色（这样就不会挡住分割线）
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    // 如果选中这个cell，The selection affects the appearance of labels, image, and background.
    
    // 如果选中这个cell，就把文字颜色设置为红色，如果没有选中，设置文字颜色为深灰色
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor darkGrayColor];
    // 如果没有选中这个cell，就隐藏左边的选中指示器
    self.selectedIndicator.hidden = !selected;
}


- (void)setCategory:(LINCategory *)category {
    _category = category;
    
    // 设置cell的文字
    self.textLabel.text = category.name;
}

@end
