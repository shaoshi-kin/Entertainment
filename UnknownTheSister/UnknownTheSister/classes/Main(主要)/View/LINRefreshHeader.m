//
//  LINRefreshHeader.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/28.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINRefreshHeader.h"

@implementation LINRefreshHeader


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 设置状态文字
        // self.stateLabel.textColor = [UIColor redColor];
        self.stateLabel.font = [UIFont systemFontOfSize:15];
        [self setTitle:@"继续下拉刷新数据" forState:MJRefreshStateIdle];
        [self setTitle:@"松开马上刷新数据" forState:MJRefreshStatePulling];
        [self setTitle:@"正在拼命刷新数据" forState:MJRefreshStateRefreshing];
        
        // 隐藏最后刷新时间
        // self.lastUpdatedTimeLabel.hidden = YES;
        
        // 自动设置切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

@end
