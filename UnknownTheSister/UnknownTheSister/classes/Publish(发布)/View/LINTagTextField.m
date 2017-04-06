//
//  LINTagTextField.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTagTextField.h"

@implementation LINTagTextField


/**
 监听键盘内部的删除键点击
 */
- (void)deleteBackward {
    // 执行需要做的操作
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    
    [super deleteBackward];
}

@end
