//
//  LINPlaceholderTextView.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LINPlaceholderTextView : UITextView

/** 占位文字 */
@property (copy, nonatomic) NSString *placeholder;
/** 占位文字颜色 */
@property (strong, nonatomic) UIColor *placeholderColor;

@end
