/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Laurin Brandner
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import "objc/runtime.h"
#import "NSImage+WebCache.h"

@implementation UIImage (GIF)

//+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
//    if (!data) {
//        return nil;
//    }
//
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//
//    size_t count = CGImageSourceGetCount(source);
//
//    UIImage *staticImage;
//
//    if (count <= 1) {
//        staticImage = [[UIImage alloc] initWithData:data];
//    } else {
//        // we will only retrieve the 1st frame. the full GIF support is available via the FLAnimatedImageView category.
//        // this here is only code to allow drawing animated images as static ones
//#if SD_WATCH
//        CGFloat scale = 1;
//        scale = [WKInterfaceDevice currentDevice].screenScale;
//#elif SD_UIKIT
//        CGFloat scale = 1;
//        scale = [UIScreen mainScreen].scale;
//#endif
//        
//        CGImageRef CGImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
//#if SD_UIKIT || SD_WATCH
//        UIImage *frameImage = [UIImage imageWithCGImage:CGImage scale:scale orientation:UIImageOrientationUp];
//        staticImage = [UIImage animatedImageWithImages:@[frameImage] duration:0.0f];
//#elif SD_MAC
//        staticImage = [[UIImage alloc] initWithCGImage:CGImage size:NSZeroSize];
//#endif
//        CGImageRelease(CGImage);
//    }
//
//    CFRelease(source);
//
//    return staticImage;
//}


+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}


- (BOOL)isGIF {
    return (self.images != nil);
}

@end
