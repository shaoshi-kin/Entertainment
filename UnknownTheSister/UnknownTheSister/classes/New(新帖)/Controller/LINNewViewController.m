//
//  LINNewViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINNewViewController.h"
#import "LINSubTagViewController.h"

@interface LINNewViewController ()

@end

@implementation LINNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.view.backgroundColor = [UIColor yellowColor];
    
    // 设置导航条
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航条
- (void)setupNavigationBar {
    // 注意：把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highlightedImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClicked)];
    
    // 设置中间titleView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.titleView = imageView;
}

#pragma mark - 点击订阅标签时调用
- (void)tagClicked {
    // 进入推荐标签界面
    LINSubTagViewController *subTagTVC = [[LINSubTagViewController alloc] init];
    [self.navigationController pushViewController:subTagTVC animated:YES];
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
