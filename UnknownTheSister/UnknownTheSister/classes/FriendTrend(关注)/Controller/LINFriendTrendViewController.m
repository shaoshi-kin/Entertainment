//
//  LINFriendTrendViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINFriendTrendViewController.h"
#import "LINLoginAndRegisterViewController.h"
#import "UITextField+placeHolder.h"
#import "LINRecommentTopicViewController.h"

@interface LINFriendTrendViewController ()

@end

@implementation LINFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航条
    [self setupNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录注册按钮触发的方法
- (IBAction)loginAndRegisterBtnClicked:(UIButton *)sender {
    // 进入登录注册界面
    LINLoginAndRegisterViewController *loginVC = [[LINLoginAndRegisterViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - 设置导航条
- (void)setupNavigationBar {
    // 注意：把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highlightedImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendRecommentClicked)];
    
    // 设置中间title
    self.navigationItem.title = @"我的关注";
}

- (void)friendRecommentClicked {
    LINRecommentTopicViewController *recommentVC = [[LINRecommentTopicViewController alloc] init];
    [self.navigationController pushViewController:recommentVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
