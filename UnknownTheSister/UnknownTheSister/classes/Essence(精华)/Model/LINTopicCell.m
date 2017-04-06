//
//  LINTopicCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/20.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicCell.h"
#import "LINTopic.h"
#import <UIImageView+WebCache.h>

#import "LINTopicVideoView.h"
#import "LINTopicVoiceView.h"
#import "LINTopicPictureView.h"
#import "LINTopicComment.h"
#import "LINTopicUser.h"

@interface LINTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

// 中间控件
@property (weak, nonatomic) LINTopicVideoView *videoView;
@property (weak, nonatomic) LINTopicVoiceView *voiceView;
@property (weak, nonatomic) LINTopicPictureView *pictureView;

@end

@implementation LINTopicCell

#pragma mark - 懒加载中间控件
- (LINTopicVideoView *)videoView {
    if (!_videoView) {
        LINTopicVideoView *videoView = [LINTopicVideoView LIN_viewFromNib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (LINTopicVoiceView *)voiceView {
    if (!_voiceView) {
        LINTopicVoiceView *voiceView = [LINTopicVoiceView LIN_viewFromNib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (LINTopicPictureView *)pictureView {
    if (!_pictureView) {
        LINTopicPictureView *pictureView = [LINTopicPictureView LIN_viewFromNib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 设置cell的backgroundView的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}



- (void)setTopic:(LINTopic *)topic {
    _topic = topic;
    
    // 设置顶部控件的具体数据
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 如果图片下载失败，直接返回，按照它的默认做法
        if (!image) return ;
        
        // 设置从服务器成功下载的图片
        self.profileImageView.image = image;
    }];
    self.profileImageView.layer.cornerRadius = 17.5;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.myTextLabel.text = topic.text;
    
    // 设置底部控件的具体数据
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    // 最热评论
    if (self.topic.topComment) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        NSString *username = topic.topComment.user.username;
        NSString *content = topic.topComment.content;
        if (content.length == 0) {
            content = @"【语音评论】";
        }
        NSString *commentText = [NSString stringWithFormat:@"%@ : %@", username, content];
        self.topCmtLabel.text = commentText;
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 中间内容
    if (topic.type == LINTopicTypeVideo) { // 视频
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        
        self.videoView.topic = topic;
        
    } else if (topic.type == LINTopicTypeVoice) { // 声音
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        
        self.voiceView.topic = topic;
        
    } else if (topic.type == LINTopicTypePicture) { // 图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        
        self.pictureView.topic = topic;
        
    } else if (topic.type == LINTopicTypeWord) { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
}

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}


- (void)setFrame:(CGRect)frame {
    // 设置cell之间的分割线
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.topic.type == LINTopicTypeVideo) { // 视频
        self.videoView.frame = self.topic.middleFrame;
    } else if (self.topic.type == LINTopicTypeVoice) { // 声音
        self.voiceView.frame = self.topic.middleFrame;
    } else if (self.topic.type == LINTopicTypePicture) { // 图片
        self.pictureView.frame = self.topic.middleFrame;
    }
}


- (IBAction)moreClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *collectionAction = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"收藏！");
    }];
    [alertController addAction:collectionAction];
    
    UIAlertAction *warnAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"举报！");
    }];
    [alertController addAction:warnAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消！");
    }];
    [alertController addAction:cancelAction];
    
    // 呈现UIAlertController
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
}


@end
