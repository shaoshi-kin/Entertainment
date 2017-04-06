//
//  UIImageView+download.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/24.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "UIImageView+download.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>


@implementation UIImageView (download)


- (void)LIN_setOriginalImage:(NSString *)originalImageStr thumbnailImage:(NSString *)thumbnailImageStr plaecholder:(UIImage *)placeholder {
    // 占位图片
    UIImage *placeholderImage = nil;
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 从缓存中获得原图 （SDWebImage的图片缓存是用图片的URL字符串作为key）
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageStr];
    if (originalImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originalImageStr] placeholderImage:placeholderImage];
    } else { // 原图未被下载过
        if (manager.isReachableViaWiFi) {
            // 如果缓存中有图片，先去缓存中取，如果缓存中没有图片，就从URL中下载图片
            [self sd_setImageWithURL:[NSURL URLWithString:originalImageStr] placeholderImage:placeholderImage];
        } else if (manager.isReachableViaWWAN) {
            // 3G\4G网络下是否需要下载原图 （特殊增加，这个项目没有要求）
            BOOL downloadOriginalImageWhen3GOr4G;
            if (downloadOriginalImageWhen3GOr4G) { // 下载原图
                [self sd_setImageWithURL:[NSURL URLWithString:originalImageStr] placeholderImage:placeholderImage];
            } else { // 下载缩略图
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageStr] placeholderImage:placeholderImage];
            }
        } else { // 没有可用网络
            // 从沙盒缓存中获取缩略图
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageStr];
            if (thumbnailImage) { // 缩略图已被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageStr] placeholderImage:placeholderImage];
            } else { // 缩略图未被下载过，设置占位图片
                [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
            }
        }
    }

}


// 设置头像
- (void)setHeader:(NSString *)url{
    [self setCycleHeader:url];
}

// 设置圆角头像
- (void)setCycleHeader:(NSString *)url {
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] cycleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 如果图片下载失败，就不做任何处理，按照默认的做法，会显示展位图片
        if (image == nil) return ;
        
        self.image = [image cycleImage];
    }];
}


@end
