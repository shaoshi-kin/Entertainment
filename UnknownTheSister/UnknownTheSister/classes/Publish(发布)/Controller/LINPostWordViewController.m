//
//  LINPostWordViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINPostWordViewController.h"
#import "LINPlaceholderTextView.h"
#import "LINPostWordToolBar.h"
#import <SVProgressHUD.h>

@interface LINPostWordViewController () <UITextViewDelegate>

/** 文本框视图 */
@property (weak, nonatomic) LINPlaceholderTextView *textView;
/** 工具条 */
@property (weak, nonatomic) LINPostWordToolBar *toolBar;

@end

@implementation LINPostWordViewController

#pragma mark - viewDidLoad方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setupNavigationItem];
    // 设置文本框视图
    [self setupTextView];
    // 设置工具条
    [self setupToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

/**
 设置导航栏
*/
- (void)setupNavigationItem {
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制刷新（能马上刷新现在的状态）
    [self.navigationController.navigationBar layoutIfNeeded];
}

/**
 设置文本框视图
 */
- (void)setupTextView {
    LINPlaceholderTextView *textView = [[LINPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    // 不管有多少内容，竖直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    self.textView = textView;
}

/**
 设置工具条
 */
- (void)setupToolBar {
    LINPostWordToolBar *toolBar = [LINPostWordToolBar LIN_viewFromNib];
    toolBar.lin_x = 0;
    toolBar.lin_y = self.view.lin_height - toolBar.lin_height;
    toolBar.lin_width = self.view.lin_width;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 监听键盘的通知
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 = 键盘的最终y值 - 屏幕的高度
        CGFloat ty = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - LINScreenH;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

#pragma mark - dealloc方法
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 导航栏左右按钮的触发方法
- (void)cancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post {
    NSLog(@"发布");
    
    LINWeakSelf;
    [SVProgressHUD showWithStatus:@"发布成功"];
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}



#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


@end
