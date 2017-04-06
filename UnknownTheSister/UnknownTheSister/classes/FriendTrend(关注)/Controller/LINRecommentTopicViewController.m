//
//  LINRecommentTopicViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/29.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINRecommentTopicViewController.h"
#import "LINUser.h"
#import "LINCategory.h"
#import "LINUserCell.h"
#import "LINCategoryCell.h"

#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>


static NSString * const categoryCellID = @"category";
static NSString * const userCellID = @"user";
@interface LINRecommentTopicViewController () <UITableViewDelegate, UITableViewDataSource>

// 左边的类别表格
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
// 右边的用户表格
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
// 网络请求管理者
@property (strong, nonatomic) AFHTTPSessionManager *manager;
// 左边类别数据
@property (strong, nonatomic) NSArray *categories;


@end

@implementation LINRecommentTopicViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    
    [self setupRefresh];
    
    [self loadCatrgories];

}

#pragma mark - 懒加载网络请求管理者
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)setupRefresh {
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUser)];
}

#pragma mark - categoryTableView and userTableView
- (void)setupTable {
    self.title = @"推荐关注";
//    self.view.backgroundColor = [UIColor greenColor];
    
    // categoryTableView
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets inset = UIEdgeInsetsMake(LINNavMaxY, 0, 0, 0);
    self.categoryTableView.contentInset = inset;
    self.categoryTableView.scrollIndicatorInsets = inset;
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LINCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryCellID];
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // usertableView
    self.userTableView.rowHeight = 70;
    self.userTableView.contentInset = inset;
    self.userTableView.scrollIndicatorInsets = inset;
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LINUserCell class]) bundle:nil] forCellReuseIdentifier:userCellID];
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)dealloc {
    // 停止网络请求任务
    [self.manager invalidateSessionCancelingTasks:YES];
}

#pragma mark - 加载数据
- (void)loadCatrgories {
    // 弹框
    [SVProgressHUD show];
    
    // 请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据请求成功，弹框消失
        [SVProgressHUD dismiss];
        
        // NSLog(@"%@", responseObject);
        
        // 字典数组->模型数组
        self.categories = [LINCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.categoryTableView reloadData];
        
        // 选中左边第0行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让右边表格进行下拉刷新
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void)loadNewUsers {
    // 取消之前的任务请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"list";
    parameter[@"c"] = @"subscribe";
    // 左边选中的类别的ID
    LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    parameter[@"category_id"] = selectedCategory.ID;
    
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 重置当前页码为1
        selectedCategory.page = 1;
        
        // 存储总数
        selectedCategory.total = [responseObject[@"total"] integerValue];
        
        // 存储用户数据
        selectedCategory.users = [LINUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新右边表格
        [self.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
            self.userTableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreUser {
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"list";
    parameter[@"c"] = @"subscribe";
    // 左边选中类别的ID
    LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    parameter[@"category_id"] = selectedCategory.ID;
    // 页码
    NSInteger page = selectedCategory.page + 1;
    parameter[@"page"] = @(page);
    
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 设置当前的最新页码
        selectedCategory.page = page;
        
        // 存储总数
        selectedCategory.total = [responseObject[@"total"] integerValue];
        
        // 添加新的用户数据到以前的数组
        NSArray *newUsers = [LINUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [selectedCategory.users addObjectsFromArray:newUsers];
        
        // 刷新右边表格
        [self.userTableView reloadData];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
            self.userTableView.mj_footer.hidden = YES;
        } else { // 可能还会有下一页数据
            // 结束刷新
            [self.userTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 左边类别表格
        return self.categories.count;
    } else { // 右边用户表格
        // 左边选中的类别
        LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        return selectedCategory.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) { // 左边选中的类别
        LINCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellID];
        cell.category = self.categories[indexPath.row];
        return cell;
    } else {
        LINUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellID];
        // 左边选择的类别
        LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = selectedCategory.users[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {
        // NSLog(@"%@",self.categories);
        // 点击左边的类别表格，刷新右边的用户表格
        LINCategory *selectedCategory = self.categories[indexPath.row];
        [self.userTableView reloadData];
        
        // 判断footer是否应该显示
        if (selectedCategory.users.count >= selectedCategory.total) {
            // 该组的用户数据已经加载完毕，隐藏footer
            self.userTableView.mj_footer.hidden = YES;
        }
        
        // 判断是否有过用户数据
        if (selectedCategory.users.count == 0) { // 从未有过用户数据
            // 加载右边的用户数据
            [self.userTableView.mj_header beginRefreshing];
        }
    } else {
        NSLog(@"点击了右边的%zd行", (long)indexPath.row);
    }
}

@end







//  XMGRecommendFollowViewController.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/20.
//  Copyright (c) 2015年 xiaomage. All rights reserved.


//#import "LINRecommentTopicViewController.h"
//#import "LINUser.h"
//#import "LINCategory.h"
//#import "LINUserCell.h"
//#import "LINCategoryCell.h"
//
//#import <MJExtension.h>
//#import <SVProgressHUD.h>
//#import <AFNetworking.h>
//#import <MJRefresh.h>
//
//
//@interface LINRecommentTopicViewController () <UITableViewDataSource, UITableViewDelegate>
///** 左边👈 ←的类别表格 */
//@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
///** 右边👉 →的用户表格 */
//@property (weak, nonatomic) IBOutlet UITableView *userTableView;
///** 请求管理者 */
//@property (nonatomic, weak) AFHTTPSessionManager *manager;
///** 左边👈 ←的类别数据 */
//@property (nonatomic, strong) NSArray *categories;
//@end
//
//@implementation LINRecommentTopicViewController
//
//#pragma mark - 懒加载
//- (AFHTTPSessionManager *)manager
//{
//    if (!_manager) {
//        _manager = [AFHTTPSessionManager manager];
//    }
//    return _manager;
//}
//
//static NSString * const XMGCategoryCellId = @"category";
//static NSString * const XMGUserCellId = @"user";
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self setupTable];
//    
//    [self setupRefresh];
//    
//    [self loadCategories];
//}
//
//- (void)setupRefresh
//{
//    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
//    
//    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
//}
//
//- (void)setupTable
//{
//    self.title = @"推荐关注";
////    self.view.backgroundColor = XMGCommonBgColor;
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIEdgeInsets inset = UIEdgeInsetsMake(LINNavMaxY, 0, 0, 0);
//    self.categoryTableView.contentInset = inset;
//    self.categoryTableView.scrollIndicatorInsets = inset;
//    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LINCategoryCell class]) bundle:nil] forCellReuseIdentifier:XMGCategoryCellId];
//    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    self.userTableView.rowHeight = 70;
//    self.userTableView.contentInset = inset;
//    self.userTableView.scrollIndicatorInsets = inset;
//    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LINUserCell class]) bundle:nil] forCellReuseIdentifier:XMGUserCellId];
//    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}
//
//- (void)dealloc
//{
//    [self.manager invalidateSessionCancelingTasks:YES];
//}
//
//#pragma mark - 加载数据
//- (void)loadCategories
//{
//    // 弹框
//    [SVProgressHUD show];
//    
//    // 请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"a"] = @"category";
//    params[@"c"] = @"subscribe";
//    
//    // 发送请求
//
//    [self.manager GET:LINCommentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //数据请求成功，弹框消失
//        [SVProgressHUD dismiss];
//        
//        [responseObject writeToFile:@"/Users/kingshaoshi/Desktop/recomment.plist" atomically:YES];
//        
//        // 字典数组 -> 模型数组
//        self.categories = [LINCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        
//        // 刷新表格
//        [self.categoryTableView reloadData];
//        
//        // 选中左边的第0行
//        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//        
//        // 让右边表格进入下拉刷新
//        [self.userTableView.mj_header beginRefreshing];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
//    }];
//}
//
//- (void)loadNewUsers
//{
//    // 取消之前的请求
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    
//    // 请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"a"] = @"list";
//    params[@"c"] = @"subscribe";
//    // 左边选中的类别的ID
//    LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
//    params[@"category_id"] = selectedCategory.ID;
//    
//    NSLog(@"selectedCategory.ID = %@", selectedCategory.ID);
//    
//    // 发送请求
//    
//    [self.manager GET:LINCommentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [responseObject writeToFile:@"/Users/kingshaoshi/Desktop/users.plist" atomically:YES];
//        
//        // 重置页码为1
//        selectedCategory.page = 1;
//        
//        // 存储总数
//        selectedCategory.total = [responseObject[@"total"] integerValue];
//        
//        // 存储用户数据
//        selectedCategory.users = [LINUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        
//        // 刷新右边表格
//        [self.userTableView reloadData];
//        
//        // 结束刷新
//        [self.userTableView.mj_header endRefreshing];
//        
//        if (selectedCategory.users.count >= selectedCategory.total) {
//            // 这组的所有用户数据已经加载完毕
//            self.userTableView.mj_footer.hidden = YES;
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        // 结束刷新
//        [self.userTableView.mj_header endRefreshing];
//    }];
//}
//
//- (void)loadMoreUsers
//{
//    // 取消之前的请求
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    
//    // 请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"a"] = @"list";
//    params[@"c"] = @"subscribe";
//    // 左边选中的类别的ID
//    LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
//    params[@"category_id"] = selectedCategory.ID;
//    // 页码
//    NSInteger page = selectedCategory.page + 1;
//    params[@"page"] = @(page);
//    
//    // 发送请求
//    
//    [self.manager GET:LINCommentURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [responseObject writeToFile:@"/Users/kingshaoshi/Desktop/moreUsers.plist" atomically:YES];
//        
//        // 设置当前的最新页码
//        selectedCategory.page = page;
//        
//        // 存储总数
//        selectedCategory.total = [responseObject[@"total"] integerValue];
//        
//        // 追加新的用户数据到以前的数组中
//        NSArray *newUsers = [LINUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        [selectedCategory.users addObjectsFromArray:newUsers];
//        
//        // 刷新右边表格
//        [self.userTableView reloadData];
//        
//        
//        NSLog(@"selectedCategory.users.count = %ld", selectedCategory.users.count);
//        NSLog(@"selectedCategory.total = %ld", selectedCategory.total);
//        
//        if (selectedCategory.users.count >= selectedCategory.total) {
//            // 这组的所有用户数据已经加载完毕
//            self.userTableView.mj_footer.hidden = YES;
//        } else { // 还可能会有下一页用户数据
//            // 结束刷新
//            [self.userTableView.mj_footer endRefreshing];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        // 结束刷新
//        [self.userTableView.mj_footer endRefreshing];
//    }];
//}
//
//#pragma mark - <UITableViewDataSource>
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
//        return self.categories.count;
//    } else { // 右边的用户表格 👉 →
//        // 左边选中的类别
//        LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
//        return selectedCategory.users.count;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
//        LINCategoryCell *cell =  [tableView dequeueReusableCellWithIdentifier:XMGCategoryCellId];
//        
//        cell.category = self.categories[indexPath.row];
//        
//        return cell;
//    } else { // 右边的用户表格 👉 →
//        LINUserCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGUserCellId];
//        
//        // 左边选中的类别
//        LINCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
//        cell.user = selectedCategory.users[indexPath.row];
//        
//        return cell;
//    }
//}
//
//#pragma mark - <UITableViewDelegate>
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == self.categoryTableView) { // 左边的类别表格 👈 ←
//        LINCategory *selectedCategory = self.categories[indexPath.row];
//        
//        // 刷新右边的用户表格 👉 →
//        // （MJRefresh的默认做法：表格有数据，就会自动显示footer，表格没有数据，就会自动隐藏footer）
//        // MJRefresh的默认做法是，表格有数据，就会自动显示footer，表格没有数据，就会自动隐藏footer
//        [self.userTableView reloadData];
//        
//        // 判断footer是否应该显示
//        if (selectedCategory.users.count >= selectedCategory.total) {
//            // 这组的所有用户数据已经加载完毕
//            self.userTableView.mj_footer.hidden = YES;
//        }
//        
//        // 判断是否有过用户数据
//        if (selectedCategory.users.count == 0) { // 从未有过用户数据
//            // 加载右边的用户数据
//            [self.userTableView.mj_header beginRefreshing];
//        }
//    } else { // 右边的用户表格 👉 →
//        // XMGLog(@"点击了👉→的%zd行", indexPath.row);
//    }
//}
//
//@end

