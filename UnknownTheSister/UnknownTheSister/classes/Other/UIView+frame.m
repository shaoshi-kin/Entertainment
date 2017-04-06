//
//  UIView+frame.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/6.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

- (void)setLin_x:(CGFloat)lin_x {
    CGRect rect = self.frame;
    rect.origin.x = lin_x;
    self.frame = rect;
}

- (CGFloat)lin_x {
    return self.frame.origin.x;
}

- (void)setLin_y:(CGFloat)lin_y {
    CGRect rect = self.frame;
    rect.origin.y = lin_y;
    self.frame = rect;
}

- (CGFloat)lin_y {
    return self.frame.origin.y;
}

- (void)setLin_width:(CGFloat)lin_width {
    CGRect rect = self.frame;
    rect.size.width = lin_width;
    self.frame = rect;
}

- (CGFloat)lin_width {
    return self.frame.size.width;
}

- (void)setLin_height:(CGFloat)lin_height {
    CGRect rect = self.frame;
    rect.size.height = lin_height;
    self.frame = rect;
}

- (CGFloat)lin_height {
    return self.frame.size.height;
}

- (void)setLin_centerX:(CGFloat)lin_centerX {
    CGPoint center = self.center;
    center.x = lin_centerX;
    self.center = center;
}

- (CGFloat)lin_centerX {
    return self.center.x;
}

- (void)setLin_centerY:(CGFloat)lin_centerY {
    CGPoint center = self.center;
    center.y = lin_centerY;
    self.center = center;
}

- (CGFloat)lin_centerY {
    return self.center.y;
}

- (void)setLin_maxX:(CGFloat)lin_maxX {
    self.lin_x = lin_maxX - self.lin_width;
}

- (CGFloat)lin_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setLin_maxY:(CGFloat)lin_maxY {
    self.lin_y = lin_maxY - self.lin_height;
}

- (CGFloat)lin_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setLin_size:(CGSize)lin_size {
    CGRect frame = self.frame;
    frame.size = lin_size;
    self.frame = frame;
}

- (CGSize)lin_size {
    return self.frame.size;
}


/**
 从nib中加载view
 */
+ (instancetype)LIN_viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


/**
 展示主窗口
 */
- (BOOL)isShowingOnKeyWindow {
    // 主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    // 以主窗口左上角为坐标原点，计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect windowBounds = keyWindow.bounds;
    
    // 主窗口的bounds和self的矩形框是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, windowBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

@end
