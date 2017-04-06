//
//  UIView+frame.h
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/6.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)


@property (assign, nonatomic) CGFloat lin_x;
@property (assign, nonatomic) CGFloat lin_y;
@property (assign, nonatomic) CGFloat lin_width;
@property (assign, nonatomic) CGFloat lin_height;
@property (assign, nonatomic) CGFloat lin_centerX;
@property (assign, nonatomic) CGFloat lin_centerY;
@property (assign, nonatomic) CGFloat lin_maxX;
@property (assign, nonatomic) CGFloat lin_maxY;
@property (assign, nonatomic) CGSize lin_size;


/**
 从nib中加载view
 */
+ (instancetype)LIN_viewFromNib;


/** 展示主窗口 */
- (BOOL) isShowingOnKeyWindow;
@end
