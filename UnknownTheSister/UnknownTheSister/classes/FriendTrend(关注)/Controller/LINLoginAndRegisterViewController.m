//
//  LINLoginAndRegisterViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/8.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINLoginAndRegisterViewController.h"
#import "LINLoginAndRegisterView.h"
#import "LINFastLoginView.h"

@interface LINLoginAndRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraints;

@end

@implementation LINLoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 创建登录View
     UIView *loginView = [LINLoginAndRegisterView loginView];
    // 添加到middleView
     [self.middleView addSubview:loginView];
    
    // 创建注册View
    UIView *registerView = [LINLoginAndRegisterView registerView];
    // 添加到middleView
    [self.middleView addSubview:registerView];
    
    // 创建快速登录view
    LINFastLoginView *fastLoginView = [LINFastLoginView FastLoginView];
    // 添加到bottomView
    [self.buttomView addSubview:fastLoginView];
}

// 根据布局调整控件的位置
- (void)viewDidLayoutSubviews {
    // 设置登录view的xib位置
    LINLoginAndRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.lin_width * 0.5, self.middleView.lin_height);
    
    // 设置注册view的xib位置
    LINLoginAndRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.lin_width * 0.5, 0, self.middleView.lin_width * 0.5, self.middleView.lin_height);
    
    // 设置快速登录view的xib位置
    LINFastLoginView *fastView = self.buttomView.subviews.firstObject;
    fastView.frame = self.buttomView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - topView方法
// 关闭注册界面
- (IBAction)closeBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击注册或登录
- (IBAction)registerBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    // 平移middleView, 改变约束
    self.leadingConstraints.constant = sender.selected ? -self.middleView.lin_width * 0.5 : 0;
    [UIView animateWithDuration:0.2 animations:^{
        // 重新约束子控件
        [self.view layoutIfNeeded];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
