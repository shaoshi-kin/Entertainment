//
//  LINTagTextField.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINTagTextField : UITextField


/** 点击删除键需要执行的操作 */
@property (copy, nonatomic) void (^deleteBackwardOperation)();

@end
