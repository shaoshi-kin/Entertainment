//
//  LINTopicVideoView.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/24.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicVideoView.h"
#import "LINTopic.h"
#import "LINSeeBigPictureViewController.h"
#import "LINSeeVideoViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LINTopicVideoView () <AVPlayerViewControllerDelegate>

@property (strong, nonatomic) AVPlayerViewController *playerVC;
@property (strong, nonatomic) AVPlayer *player;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;




@end

@implementation LINTopicVideoView

//+ (AccountManager *)sharedManager
//{
//    static AccountManager *sharedAccountManagerInstance = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        sharedAccountManagerInstance = [[self alloc] init];
//    });
//    return sharedAccountManagerInstance;
//}

//- (AVPlayerViewController *)sharedAVPlayerViewcontroller {
//    __block AVPlayerViewController *playerVC = nil;
//    dispatch_once_t once;
//    dispatch_once(&once, ^{
//        playerVC = [[AVPlayerViewController alloc] init];
//    });
//    return playerVC;
//    
//}

- (IBAction)videoButtonClicked:(id)sender {
    
    // LINSeeVideoViewController *videoVC = [[LINSeeVideoViewController alloc] init];
    
    // [UIApplication sharedApplication].keyWindow.rootViewController.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:videoVC animated:YES completion:nil];
    
    NSURL *url = [NSURL URLWithString:self.topic.videouri];
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = [AVPlayer playerWithURL:url];
    
    // 设置拉伸模式
    self.playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
    // 设置代理
    self.playerVC.delegate = self;
    // 播放视频
    [self.playerVC.player play];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.playerVC animated:YES completion:nil];
    
    // [self addChildViewController:self.playerVC];
    // [self.videoView1 addSubview:self.playerVC.view];
    // self.playerVC.view.frame = self.videoView1.frame;
    
//    self.definesPresentationContext = YES; //self is presenting view controller
//    self.playerVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//    self.playerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
//    [self presentViewController:self.playerVC animated:YES completion:nil];
    
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
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
    
}

@end
