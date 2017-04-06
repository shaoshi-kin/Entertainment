//
//  NSDate+LINExtension.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "NSDate+LINExtension.h"

@implementation NSDate (LINExtension)

- (NSDateComponents *)intervalToDate:(NSDate *)date {
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较哪些日历元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 比较
    return [calendar components:unit fromDate:self toDate:date options:0];
}

- (NSDateComponents *)intervalToNow {
    return [self intervalToDate:[NSDate date]];
}

// 是否为今年
- (BOOL)isThisYear {
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得年
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

// 是否为今天
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    
    return nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day;
}

// 是否为昨天
- (BOOL)isYesterday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [formatter dateFromString:nowString];
    
    NSString *selfString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0 && components.month == 0 && components.day == 1;
}

// 是否为明天
- (BOOL)isTomorrow {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [formatter dateFromString:nowString];
    
    NSString *selfString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0 && components.month == 0 && components.day == -1;
}



//- (BOOL)isThisYear {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy";
//    
//    NSString *nowYear = [formatter stringFromDate:[NSDate date]];
//    NSString *selfYear = [formatter stringFromDate:self];
//    
//    return [nowYear isEqualToString:selfYear];
//}

//- (BOOL)isToday {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    
//    NSString *nowDay = [formatter stringFromDate:[NSDate date]];
//    NSString *selfDate = [formatter stringFromDate:self];
//    
//    return [nowDay isEqualToString:selfDate];
//}

//- (BOOL)isToday {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSDate *now = [NSDate date];
//    
//    return [calendar component:NSCalendarUnitYear fromDate:now] == [calendar component:NSCalendarUnitYear fromDate:self] && [calendar component:NSCalendarUnitMonth fromDate:now] == [calendar component:NSCalendarUnitMonth fromDate:self] && [calendar component:NSCalendarUnitDay fromDate:now] == [calendar component:NSCalendarUnitDay fromDate:self];
//}



@end
