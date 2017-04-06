//
//  LINTabBar.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTabBar.h"
#import "LINPublishViewController.h"


@interface LINTabBar ()

@property (weak, nonatomic) UIButton *publishBtn;

// 上一次点击的tabBarButton
@property (weak, nonatomic) UIControl *previousClickedTabBarBtn;

@end

@implementation LINTabBar

- (UIButton *)publishBtn {
    if (_publishBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(publishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [btn sizeToFit];
        
        _publishBtn = btn;
    }
    return _publishBtn;
}

- (void)publishBtnClicked {
    LINPublishViewController *pubVC = [[LINPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pubVC animated:YES completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.items.count;
    CGFloat btnW = self.lin_width / (count + 1);
    CGFloat btnH = self.lin_height;
    CGFloat x = 0;
    int i = 0;
    
    // 遍历子控件，调整布局
    for (UIControl *tabBarBtn in self.subviews) {
        if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置previousClickedTabBarButton默认值为最前面的按钮
            if (i == 0 && self.previousClickedTabBarBtn == nil) {
                self.previousClickedTabBarBtn = tabBarBtn;
            }
            
            if (i == 2) {
                i += 1;
            }
            
            x = i * btnW;
            
            tabBarBtn.frame = CGRectMake(x, 0, btnW, btnH);
            
            i++;
            
            // 监听点击
            [tabBarBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // 调整发布按钮位置
    self.publishBtn.center = CGPointMake(self.lin_width / 2, self.lin_height / 2);
}

// 监听点击
- (void)tabBarButtonClicked:(UIControl *)tabBarBtn {
    if (self.previousClickedTabBarBtn == tabBarBtn) {
        
        // 发出通知，告诉tabBarButton被点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:LINTabBarButtonDidRepeatClickNotification object:nil];
        
    }
    
    self.previousClickedTabBarBtn = tabBarBtn;
}

@end
