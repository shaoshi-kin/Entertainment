//
//  LINTabBarController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTabBarController.h"
#import "LINEssenceViewController.h"
#import "LINPublishViewController.h"
#import "LINFriendTrendViewController.h"
#import "LINMeTableViewController.h"
#import "LINNewViewController.h"
#import "UIImage+image.h"
#import "LINTabBar.h"
#import "LINNavigationViewController.h"

@interface LINTabBarController ()

@end

@implementation LINTabBarController

// 只会调用一次
+ (void)load {
    // 获取哪个类中的UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // 创建一个描述文本属性的文件
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    // 设置文字颜色
    attrDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    
    // 设置字体尺寸，只有设置正常状态下才有效果
    NSMutableDictionary *attrDict1 = [NSMutableDictionary dictionary];
    // 设置字体大小
    attrDict1[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrDict1 forState:UIControlStateNormal];
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加子控制器
    [self setupAllChildViewController];
    
    // 设置tabBar上按钮内容，由对应的自控制器的tabBarItem属性
    [self setupAllTabBarItemTitle];
    
    // 自定义tabBar
    [self setupTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加所有子控制器
- (void)setupAllChildViewController {
    // 精华
    LINEssenceViewController *essenceVC = [[LINEssenceViewController alloc] init];
    LINNavigationViewController *nav = [[LINNavigationViewController alloc] initWithRootViewController:essenceVC];
    [self addChildViewController:nav];
    
    // 新帖
    LINNewViewController *newVC = [[LINNewViewController alloc] init];
    LINNavigationViewController *nav1 = [[LINNavigationViewController alloc] initWithRootViewController:newVC];
    [self addChildViewController:nav1];
    
    // 关注
    LINFriendTrendViewController *friendTrendVC = [[LINFriendTrendViewController alloc] init];
    LINNavigationViewController *nav3 = [[LINNavigationViewController alloc] initWithRootViewController:friendTrendVC];
    [self addChildViewController:nav3];
    
    // 我， 控制器通过storyboard设置
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LINMeTableViewController" bundle:nil];
    LINMeTableViewController *meTVC = [storyboard instantiateInitialViewController];
    LINNavigationViewController *nav4 = [[LINNavigationViewController alloc] initWithRootViewController:meTVC];
    [self addChildViewController:nav4];
}

#pragma mark - 设置所有子控制器tabBarItem上的内容
- (void)setupAllTabBarItemTitle {
    // 精华
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    // 快速生成一个没有被渲染的图片
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    
    // 新帖
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    // 快速生成一个没有被渲染的图片
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    
    // 关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    // 快速生成一个没有被渲染的图片
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    // 我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    // 快速生成一个没有被渲染的图片
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
}

#pragma mark - 设置tabBar
- (void)setupTabBar {
    LINTabBar *tabBar = [[LINTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
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
