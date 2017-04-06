//
//  UIImage+image.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

// 返回不被系统渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)cycleImage {
    // 开启图片上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 矩形框
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 添加一个圆
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪（裁剪成刚才添加的图形形状）
    CGContextClip(context);
    
    // 往圆上面画一张图片
    [self drawInRect:rect];
    
    // 获得上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)cycleImageName:(NSString *)name {
    return [[UIImage imageNamed:name] cycleImage];
}


@end
