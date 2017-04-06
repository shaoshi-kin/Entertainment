//
//  UIImage+image.h
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

// 返回不被系统渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)imageName;


// 返回一张圆形图片
- (instancetype)cycleImage;

// 返回一张圆形图片
+ (instancetype)cycleImageName:(NSString *)name;

@end
