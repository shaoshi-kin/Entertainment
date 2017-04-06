//
//  LINAdItem.h
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/8.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINAdItem : NSObject

// 广告地址
@property (copy, nonatomic) NSString *w_picurl;
// 点击广告跳转界面
@property (copy, nonatomic) NSString *ori_curl;
@property (assign, nonatomic) CGFloat w;
@property (assign, nonatomic) CGFloat h;

@end
