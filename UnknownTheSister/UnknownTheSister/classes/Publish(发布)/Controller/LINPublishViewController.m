//
//  LINPublishViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINPublishViewController.h"
#import "LINPublicButton.h"
#import <POP.h>
#import "LINPostWordViewController.h"
#import "LINNavigationViewController.h"

static CGFloat const LINSpringFactor = 10;
@interface LINPublishViewController ()


/** 标语 */
@property (weak, nonatomic) UIImageView *sloganImageView;
/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttons;
/** 动画时间数组 */
@property (strong, nonatomic) NSArray *times;


@end

@implementation LINPublishViewController

#pragma mark - 懒加载
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)times {
    if (!_times) {
        // 时间间隔
        CGFloat interval = 0.1;
        _times = @[@(5 * interval),
                   @(4 * interval),
                   @(3 * interval),
                   @(2 * interval),
                   @(0 * interval),
                   @(1 * interval),
                   @(6 * interval)]; // 标语的动画时间
    }
    return _times;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 禁止交互
    self.view.userInteractionEnabled = NO;
    
    // 按钮
    [self setupButtons];
    
    // 标语
    [self setupSloganImageView];
    
}

- (void)setupButtons {
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 一些参数 // 万能公式计算行数：(count - 1) / cols + 1; 或 (count + maxColsCount - 1) / maxColsCount;
    NSInteger count = images.count;
    // 列数
    NSInteger colsCount = 3;
    // 行数
    NSInteger rowsCount = (count - 1) / colsCount + 1;
    
    // 按钮尺寸
    CGFloat buttonW = LINScreenW / colsCount;
    CGFloat buttonH = buttonW * 0.85;
    CGFloat buttonStartY = (LINScreenH - rowsCount * buttonH) * 0.5;
    for (int i = 0; i < count; i++) {
        // 创建，添加
        LINPublicButton *button = [LINPublicButton buttonWithType:UIButtonTypeCustom];
        // 按钮的尺寸为0，还是能看见文字缩成一点，设置按钮的尺寸为负数，那么久看不到文字了
        button.lin_width = -1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [self.buttons addObject:button];
        
        // 内容
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
        // frame
        CGFloat buttonX = (i % colsCount) * buttonW;
        CGFloat buttonY = (i / colsCount) * buttonH + buttonStartY;
        
        // 动画
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - LINScreenH, buttonW, buttonH)];
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        // Defaults to 12
        springAnimation.springSpeed = LINSpringFactor;
        // Defaults to 4
        springAnimation.springBounciness = LINSpringFactor;
        // CACurrentMediaTime()，获得的是当前时间     Defaults to 0 and starts immediately.
        springAnimation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [button pop_addAnimation:springAnimation forKey:nil];
    }
}

- (void)setupSloganImageView {
    // 添加标语
    CGFloat sloganY = LINScreenH * 0.2;
    UIImageView *sloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganImageView.lin_y = sloganY - LINScreenH;
    sloganImageView.lin_centerX = LINScreenW * 0.5;
    [self.view addSubview:sloganImageView];
    self.sloganImageView = sloganImageView;
    
    // 动画
    LINWeakSelf;
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.toValue = @(sloganY);
    springAnimation.springSpeed = LINSpringFactor;
    springAnimation.springBounciness = LINSpringFactor;
    // CACurrentMediaTime()，获得的是当前时间
    springAnimation.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [springAnimation setCompletionBlock:^(POPAnimation *springAnimation, BOOL finished) {
        // 开始交互
        weakSelf.view.userInteractionEnabled = YES;
    }];
    [sloganImageView.layer pop_addAnimation:springAnimation forKey:nil];
}

#pragma mark - 退出动画
- (void)exit:(void (^)())task {
    // 禁止交互
    self.view.userInteractionEnabled = NO;
    
    // 让按钮执行动画
    for (int i = 0; i < self.buttons.count; i++) {
        LINPublicButton *button = self.buttons[i];
        
        POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        basicAnimation.toValue = @(button.layer.position.y + LINScreenH);
        // CACurrentMediaTime()，获得的是当前时间
        basicAnimation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [button.layer pop_addAnimation:basicAnimation forKey:nil];
    }
    
    LINWeakSelf;
    // 让标题执行动画
    POPBasicAnimation *sloganBasicAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    sloganBasicAni.toValue = @(self.sloganImageView.layer.position.y + LINScreenH);
    // CACurrentMediaTime()，获取的是当前时间
    sloganBasicAni.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [sloganBasicAni setCompletionBlock:^(POPAnimation *qqq, BOOL finished) {
        // 让当前控制器消失
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 可能会做其它事
        // if (task) task();
        !task ? : task();
    }];
    [self.sloganImageView pop_addAnimation:sloganBasicAni forKey:nil];
}


#pragma mark - 点击按钮 LINPublicButton
- (void)buttonClicked:(LINPublicButton *)button {
    [self exit:^{
        // 按钮索引
        NSInteger index = [self.buttons indexOfObject:button];
        
        switch (index) {
            case 2: { // 发段子
                // 弹出发段子控制器
                LINPostWordViewController *postWordVC = [[LINPostWordViewController alloc] init];
                LINNavigationViewController *navVC = [[LINNavigationViewController alloc] initWithRootViewController:postWordVC];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navVC animated:YES completion:nil];
                break;
            }
                
            case 0:
                NSLog(@"发视频");
                break;
                
            case 1:
                NSLog(@"发图片");
                break;
                
            default:
                NSLog(@"发其它");
                break;
        }
    }];
    
}

- (IBAction)cancel:(id)sender {
    [self exit:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self exit:nil];
}

@end
