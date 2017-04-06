//
//  LINSeeBigPictureViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/26.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSeeBigPictureViewController.h"
#import "LINTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h>

@interface LINSeeBigPictureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation LINSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    // scrollView.backgroundColor = [UIColor redColor];
    // scrollView.frame = self.view.bounds;
     scrollView.frame = [[UIScreen mainScreen] bounds];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backbuttonClicked:)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    // 加载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 图片没下载成功，直接返回
        if (!image) return ;
        
        // 设置保存按钮可用
        self.saveButton.enabled = YES;
    }];
    // 设置imageView的frame
    imageView.lin_width = scrollView.lin_width;
    imageView.lin_height = imageView.lin_width * self.topic.height / self.topic.width;
    imageView.lin_x = 0;
    if (imageView.lin_height > LINScreenH) { // 超过一个屏幕
        imageView.lin_y = 0;
        self.scrollView.contentSize = CGSizeMake(0, imageView.lin_height);
    } else {
        imageView.lin_centerY = scrollView.lin_height / 2;
    }
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.lin_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}

// 视图已经布局好子控件
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - scrollView的代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - 按钮的点击事件
- (IBAction)backbuttonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender {
    
    
    // 1.请求或检查访问权限
    // 2.如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 3.如果之前已经做过选择，会直接执行block
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            
            if (oldStatus != PHAuthorizationStatusNotDetermined) {
                NSLog(@"提醒用户打开开关");
            }
            
        } else if (status == PHAuthorizationStatusAuthorized) {
            
            // 保存图片到当前app的相册中
            [self saveImageIntoAPPAlbum];
            
        } else if (status == PHAuthorizationStatusRestricted) {
            [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
        }
    }];
    
}

#pragma mark - 保存图片到当前app的相册中
- (void)saveImageIntoAPPAlbum {
    // 获取保存到胶卷相册中的照片
    PHAsset *asset = [self getAssetFromAlbum];
    if (asset == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    
    // 获得自定义相册
    PHAssetCollection *createdCollection = [self createdCollection];
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建或获取相册失败"];
        return;
    }
    
    // 把刚才保存的图片添加到自定义相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [changeRequest insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
    
}


#pragma mark - 获得当前app对应的自定义相册
- (PHAssetCollection *)createdCollection {
    // 获取当前app名字
    NSString *appName = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
    // 获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前app对应的自定义相册
    PHAssetCollection *createdCollection = nil;
    
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:appName]) {
            createdCollection = collection;
            return createdCollection;
        }
    }
    
    // 如果当前的自定义相册还没有创建
        NSError *error = nil;
        __block NSString *ID = nil;
        // 创建一个自定义相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            // 创建的相册的localIdentifier
            ID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败"];
        return nil;
    }
        
        // 根据localIdentifier获取创建的相册
        createdCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[ID] options:nil].firstObject;
    
    return createdCollection;

}


#pragma mark - 获得刚刚保存在相册胶卷中的照片
- (PHAsset *)getAssetFromAlbum {
    // 保存照片到相机胶卷中
    NSError *error = nil;
    // __block PHObjectPlaceholder *placeholder = nil;
    __block NSString *identifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        identifier = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 获取图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil].firstObject;

}


//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"照片保存失败"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"照片保存成功"];
//    }
//}





// 1.保存图片到相机胶卷 2.拥有一个自定义相册 3.添加刚才保存的图片到自定义相册

// 1.C语言函数UIImageWriteToSavedPhotosAlbum (xcode8会出现问题，点击保存会有bug) 2.AssetsLibrary框架（已经不推荐使用） 3.Photos框架 （推荐使用iOS9）


@end
