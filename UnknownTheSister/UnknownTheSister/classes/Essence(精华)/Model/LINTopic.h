//
//  LINTopic.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/19.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LINTopicComment;
/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
typedef NS_ENUM(NSInteger, LINTopicType) {
    LINTopicTypeAll = 1,
    LINTopicTypeVideo = 41,
    LINTopicTypeVoice = 31,
    LINTopicTypePicture = 10,
    LINTopicTypeWord = 29
};

@interface LINTopic : NSObject

// id
@property (copy, nonatomic) NSString *ID;
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;

/** 最热评论 */
@property (strong, nonatomic) LINTopicComment *topComment;

/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
@property (assign, nonatomic) NSInteger type;

// 图片的宽度
@property (assign, nonatomic) NSInteger width;
// 图片的高度
@property (assign, nonatomic) NSInteger height;

/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/** 是否为动图 */
@property (assign, nonatomic) BOOL is_gif;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;



@property (copy, nonatomic) NSString *videouri;
@property (copy, nonatomic) NSString *voiceuri;

/* 额外增加的属性（并非服务器返回的属性，仅仅是为了提高开发效率） */
// 根据当前模型计算出当前cell的高度
@property (assign, nonatomic) CGFloat cellHeight;
// 中间内容的frame
@property (assign, nonatomic) CGRect middleFrame;
// 是否为超长图片
@property (assign, nonatomic, getter=isBigPicture) BOOL bigPicture;


@end
