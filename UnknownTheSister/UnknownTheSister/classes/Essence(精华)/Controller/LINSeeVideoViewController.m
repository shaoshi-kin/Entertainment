//
//  LINSeeVideoViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/31.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSeeVideoViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>



@interface LINSeeVideoViewController () <AVPlayerViewControllerDelegate>


@property (strong, nonatomic) AVPlayerViewController *playerVC;
@property (strong, nonatomic) AVPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *videoView;

@end

@implementation LINSeeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (_player) {
        [_player pause];
        _player = nil;
    }
    
    if (_playerVC) {
        _playerVC = nil;
    }

    NSURL *url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/1018/14c1db8c-9486-11e6-bad2-d4ae5296039d_wpd.mp4"];
    
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = [AVPlayer playerWithURL:url];
    // 设置拉伸模式
    self.playerVC.videoGravity = AVLayerVideoGravityResizeAspect;
    // 设置代理
    self.playerVC.delegate = self;
    [self.videoView addSubview:self.playerVC.view];
    self.playerVC.view.frame = self.videoView.frame;
    
    [self.playerVC.player play];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.playerVC = nil;
    self.player = nil;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
