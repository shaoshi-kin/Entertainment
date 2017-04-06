//
//  UIImageView+download.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/24.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (download)


// 根据网络设置从服务器下载的图片是原图还是缩略图
- (void)LIN_setOriginalImage:(NSString *)originalImageStr thumbnailImage:(NSString *)thumbnailImageStr plaecholder:(UIImage *)placeholder;

// 设置头像
- (void)setHeader:(NSString *)url;

@end
