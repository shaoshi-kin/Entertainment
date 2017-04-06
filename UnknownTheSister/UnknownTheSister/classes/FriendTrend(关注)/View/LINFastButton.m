//
//  LINFastButton.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINFastButton.h"

@implementation LINFastButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.lin_y = 0;
    self.imageView.lin_centerX = self.lin_width * 0.5;
    
    // 设置标签位置
    self.titleLabel.lin_y = self.lin_height - self.titleLabel.lin_height;
    [self.titleLabel sizeToFit];
    self.titleLabel.lin_centerX = self.lin_width * 0.5;
}

@end
