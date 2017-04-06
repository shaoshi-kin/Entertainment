//
//  LINTopicPictureView.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/24.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicPictureView.h"
#import "LINTopic.h"
#import <UIImageView+WebCache.h>
#import "LINSeeBigPictureViewController.h"
#import <DALabeledCircularProgressView.h>

@interface LINTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end


@implementation LINTopicPictureView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // DALabeledCircularProgressView
    self.progressView.roundedCorners = 5;
    self.progressView.trackTintColor = LINColor(231.0, 231.0, 231.0);
    self.progressView.progressTintColor = LINColor(255.0, 255.0, 255.0);
    self.progressView.progressLabel.textColor = [UIColor darkGrayColor];
    
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
    // [self.imageView LIN_setOriginalImage:topic.image1 thumbnailImage:topic.image0 plaecholder:nil];
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://wimg.spriteapp.cn/ugc/2016/10/24/580e174bb3c54.gif"]];
//    NSLog(@"datu: %@, suoluetu: %@", topic.image1, topic.image0);
    
    
    // 下载图片
    
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        // 每下载一点图片就调用这个block
//        self.progressView.hidden = NO;
//        self.progressView.progress = 1.0 * receivedSize / expectedSize;
//        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.progressView.progress * 100];
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        // 当图片下载完毕后就调用这个block
//        self.progressView.hidden = YES;
//    }];
    
    
    // 下载图片
    LINWeakSelf;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
        // 每下载一点图片数据，就会调用一次这个block
        weakSelf.progressView.hidden = NO;
        
        // 更新UI界面，要放进主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
            weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
        });
//        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
//        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 当图片下载完毕后，就会调用这个block
        weakSelf.progressView.hidden = YES;
    }];

    // gif
    self.gifImageView.hidden = !topic.is_gif;
    
    //点击查看大图
    if (topic.isBigPicture) { // 是超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
        // 处理超长图片的大小
        if (topic.isBigPicture) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启图形上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            // 从图形上下文中获取绘制的图片
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭图形上下文
            UIGraphicsEndImageContext();
        }
    } else { // 不是超长图
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
}


@end
