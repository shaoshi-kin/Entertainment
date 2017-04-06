//
//  NSDate+LINExtension.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LINExtension)

- (NSDateComponents *)intervalToDate:(NSDate *)date;
- (NSDateComponents *)intervalToNow;


// 是否为今年
- (BOOL)isThisYear;

// 是否为今天
- (BOOL)isToday;

// 是否为昨天
- (BOOL)isYesterday;

// 是否为明天
- (BOOL)isTomorrow;

@end
