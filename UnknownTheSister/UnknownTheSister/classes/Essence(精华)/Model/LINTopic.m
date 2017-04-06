//
//  LINTopic.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/19.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopic.h"
#import "LINTopicUser.h"
#import "LINTopicComment.h"

@implementation LINTopic

// passtime
- (NSString *)passtime {
    // 日期格式化类
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // NSString -> NSDate
    NSDate *passtimeDate = [formatter dateFromString:_passtime];
    
    // 比较发帖时间和当前手机时间的差值
    NSDateComponents *components = [passtimeDate intervalToNow];
    
    if (passtimeDate.isThisYear) { // 今年
        if (passtimeDate.isToday) { // 今天
            if (components.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", components.hour];
            } else if (components.minute >= 1) { // 1 ~ 59分钟
                return [NSString stringWithFormat:@"%zd分钟前", components.minute];
            } else { // 小于1分钟
                return @"刚刚";
            }
        } else if (passtimeDate.isYesterday) { // 昨天
            formatter.dateFormat = @"昨天 HH:mm:ss";
            return [formatter stringFromDate:passtimeDate];
        } else { // 今年的其他时间
            formatter.dateFormat = @"MM-dd HH:mm:ss";
            return [formatter stringFromDate:passtimeDate];
        }
    } else { // 不是今年
        return _passtime;
    }
}


// 计算行高
- (CGFloat)cellHeight {
    
    // 如果已经计算过，直接返回
    if (_cellHeight) return _cellHeight;
    
    // 文字的Y值
    _cellHeight += 55;
    
    // 文字的高度
    CGSize cellTextSize = CGSizeMake(LINScreenW - 2 * LINMargin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:cellTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + LINMargin;
    
    // 中间内容
//    CGFloat middleW = cellTextSize.width;
//    CGFloat middleH = middleW * self.height / self.width;
//    CGFloat middleX = LINMargin;
//    CGFloat middleY = _cellHeight;
//    if (self.type == LINTopicTypePicture) {
//        CGFloat middleW = cellTextSize.width;
//        CGFloat middleH = middleW * self.height / self.width;
//        if (middleH >= LINScreenH) { // 显示的图片超过一个屏幕高度，就是超长图片
//            middleH = 250;
//            self.bigPicture = YES;
//        }
//        CGFloat middleX = LINMargin;
//        CGFloat middleY = _cellHeight;
//        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
//        _cellHeight += middleH + LINMargin;
//    }
//    
//    if (self.type == LINTopicTypeVideo) {
//        CGFloat middleW = cellTextSize.width;
//        CGFloat middleH = 250;
//        CGFloat middleX = LINMargin;
//        CGFloat middleY = _cellHeight;
//        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
//        _cellHeight += middleH + LINMargin;
//    }
//    
//    if (self.type == LINTopicTypeVoice) {
//        CGFloat middleW = cellTextSize.width;
//        CGFloat middleH = 250;
//        CGFloat middleX = LINMargin;
//        CGFloat middleY = _cellHeight;
//        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
//        _cellHeight += middleH + LINMargin;
//    }

    // 中间的内容
    if (self.type != LINTopicTypeWord) { // 中间有内容（图片、声音、视频）
        CGFloat middleW = cellTextSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= LINScreenW) { // 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 250;
            self.bigPicture = YES;
        }
        CGFloat middleY = _cellHeight;
        CGFloat middleX = LINMargin;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + LINMargin;
    }

    
    // 最热评论
    if (self.topComment) { // 有最热评论
        // 最热评论标题
        _cellHeight += 21;
        
        NSString *userName = self.topComment.user.username;
        NSString *content = self.topComment.content;
        if (content.length == 0) {
            content = @"【语音评论】";
        }
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", userName, content];
        _cellHeight += [cmtText boundingRectWithSize:cellTextSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _cellHeight += LINMargin;
    }
    
    // 工具栏的高度
    _cellHeight += 35 + LINMargin;
    
    
    return _cellHeight;
}

@end
