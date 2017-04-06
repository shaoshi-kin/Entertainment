//
//  LINTopicComment.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/7.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LINTopicUser;
@interface LINTopicComment : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (nonatomic, strong) LINTopicUser *user;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 语音文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** 语音文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

@end
