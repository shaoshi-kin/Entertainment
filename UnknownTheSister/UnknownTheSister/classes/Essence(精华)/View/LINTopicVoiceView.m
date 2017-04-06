//
//  LINTopicVoiceView.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/24.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicVoiceView.h"
#import "LINTopic.h"
#import "LINSeeBigPictureViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LINTopicVoiceView () <AVPlayerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;


@end

@implementation LINTopicVoiceView


- (IBAction)voiceButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:self.topic.voiceuri];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = [AVPlayer playerWithURL:url];
    
    // 设置拉伸模式
    playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
    // 设置代理
    playerVC.delegate = self;
    // 播放视频
    [playerVC.player play];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark *** AVPlayerViewControllerDelegate ***
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 子控件不跟随父控件发生变化
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 为图片增加点击事件，弹出保存图片的控制器，以便保存图片
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];

}

- (void)seeBigPicture {
    LINSeeBigPictureViewController *savePictureVC = [[LINSeeBigPictureViewController alloc] init];
    savePictureVC.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:savePictureVC animated:YES completion:nil];
}

- (void)setTopic:(LINTopic *)topic {
    _topic = topic;
    
    // 图片
    [self.imageView LIN_setOriginalImage:topic.image1 thumbnailImage:topic.image0 plaecholder:nil];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放量", topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放量", topic.playcount];
    }
    
    // 播放时间
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
    
}

@end
