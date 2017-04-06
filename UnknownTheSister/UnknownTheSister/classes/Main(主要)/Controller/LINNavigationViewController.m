//
//  LINNavigationViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/6.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINNavigationViewController.h"

@interface LINNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation LINNavigationViewController

+ (void)load {
    UINavigationBar *NavBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 只要是通过模型设置,都是通过富文本设置
    // 设置导航条标题----UINavigationBar
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    NavBar.titleTextAttributes = attrDict;
    
    // 设置导航条背景图片
    [NavBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 控制手势什么时候触发，只有非根控制器才能触发
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.childViewControllers.count > 1;
}

#pragma mark - 重写pushViewController: animated:
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 非根控制器，有子控制器
    if (self.childViewControllers.count > 0) {
        // 隐藏标签栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 非根控制器，设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highlightedImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"] ;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
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
