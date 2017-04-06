//
//  LINTextField.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/10.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTextField.h"
#import "UITextField+placeHolder.h"

@implementation LINTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置光标颜色
    self.tintColor = [UIColor whiteColor];
    
    // 快速方法
    self.placeHolderColor = [UIColor lightGrayColor];
    
    // 方法一：
//    // 设置占位文字的颜色
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];

    
    // 设置占位文字颜色,  开始编辑的时候
    [self addTarget:self action:@selector(textFieldDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    // 设置占位文字颜色,  结束编辑的时候
    [self addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)textFieldDidBegin {
    
    self.placeHolderColor = [UIColor whiteColor];
    
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
}

- (void)textFieldDidEnd {
    
    self.placeHolderColor = [UIColor lightGrayColor];
    
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
}

@end
