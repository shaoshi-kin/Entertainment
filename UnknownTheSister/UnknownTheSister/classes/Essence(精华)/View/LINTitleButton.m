//
//  LINTitleButton.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/14.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTitleButton.h"

@implementation LINTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    }
    return self;
}


// 只要重写了这个方法，按钮就无法进入highlighted状态
- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
