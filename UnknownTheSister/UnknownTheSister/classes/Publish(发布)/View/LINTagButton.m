//
//  LINTagButton.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTagButton.h"

@implementation LINTagButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LINTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    // 自动计算
    [self sizeToFit];
    
    // 微调
    self.lin_height = LINTagH;
    self.lin_width += 3 * LINSmallMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.lin_x = LINSmallMargin;
    self.imageView.lin_x = CGRectGetMaxX(self.titleLabel.frame) + LINSmallMargin;
}

@end
