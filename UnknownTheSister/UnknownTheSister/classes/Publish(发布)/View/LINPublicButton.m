//
//  LINPublicButton.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINPublicButton.h"

@implementation LINPublicButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.lin_y = 0;
    self.imageView.lin_centerX = self.lin_width * 0.5;
    
    self.titleLabel.lin_x = 0;
    self.titleLabel.lin_y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.lin_width = self.lin_width;
    self.titleLabel.lin_height = self.lin_height - self.titleLabel.lin_y;
}

@end
