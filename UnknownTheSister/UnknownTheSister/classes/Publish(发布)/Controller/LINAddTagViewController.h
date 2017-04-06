//
//  LINAddTagViewController.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/16.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINAddTagViewController : UIViewController

/** 传递tag数据的block，block的参数是一个字符串数组，传递数据给上一个界面 */
@property (copy, nonatomic) void (^getTagsBlock)(NSArray *);
/** 从上一个界面传来的标签数据 */
@property (strong, nonatomic) NSArray *tags;

@end
