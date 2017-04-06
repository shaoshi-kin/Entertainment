//
//  UITextField+placeHolder.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/10.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "UITextField+placeHolder.h"
#import <objc/message.h>

@implementation UITextField (placeHolder)

+ (void)load {
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setLIN_PlaceholderMethod = class_getInstanceMethod(self, @selector(setLIN_placeholder:));
    
    // 方法的实现交换
    method_exchangeImplementations(setPlaceholderMethod, setLIN_PlaceholderMethod);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    
    // 给成员属性赋值，runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeHolderColor", placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeHolderColor;
}

- (UIColor *)placeHolderColor {
    return objc_getAssociatedObject(self, @"placeHolderColor");
}

- (void)setLIN_placeholder:(NSString *)placeholder {
    
    // 设置占位文字
    [self setLIN_placeholder:placeholder];
    // 设置占位文字颜色
    self.placeHolderColor = self.placeHolderColor;
}

@end
