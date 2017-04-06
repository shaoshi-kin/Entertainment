//
//  LINTopicTableViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/17.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicTableViewController.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "LINTopic.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LINTopicCell.h"
#import <SDImageCache.h>
#import "LINRefreshHeader.h"
#import "LINComentViewController.h"
#import "LINNewViewController.h"

// cell的重用标识符
static NSString * const topicCellID = @"topicCellID";


@interface LINTopicTableViewController ()


/** 用来缓存cell的高度（key：模型，value：cell的高度） */
// @property (strong, nonatomic) NSMutableDictionary *cellHeightDict;


@property (strong, nonatomic) AFHTTPSessionManager *manager;

// 当前最后一条帖子数据的描述信息，专门用来加载下一页数据
@property (copy, nonatomic) NSString *maxtime;

// 数据量
@property (strong, nonatomic) NSMutableArray *topics;

- (NSString *)aparameter;
@end

@implementation LINTopicTableViewController

// 懒加载cellHeightDict
//- (NSMutableDictionary *)cellHeightDict {
//    if (!_cellHeightDict) {
//        _cellHeightDict = [NSMutableDictionary dictionary];
//    }
//    return _cellHeightDict;
//}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置cell的估算高度
    // self.tableView.estimatedRowHeight = 200;
    // self.view.backgroundColor = [UIColor purpleColor];
    
    // 设置tableView的穿透效果，就是设置contentInset的上下边距
    self.tableView.contentInset = UIEdgeInsetsMake(LINNavMaxY + LINTitlesViewH, 0, LINTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:@"LINTopicCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:topicCellID];
    
    
    // 接受通知，刷新显示的界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClicked) name:LINTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClicked) name:LINTitleButtonDidRepeatClickNotification object:nil];
    
    // 设置刷新
    [self setupRefresh];
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听重复点击
- (void)tabBarButtonDidRepeatClicked {
    // if (重复点击的不是精华按钮) return;
    if (self.view.window == nil) return;
    // if (显示在正中间的不是AllViewController) return;
    if (self.tableView.scrollsToTop == NO) return;
    
    NSLog(@"%@ - 刷新数据", self.class);
    
    // 进入下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)titleButtonDidRepeatClicked {
    [self tabBarButtonDidRepeatClicked];
}


#pragma mark - 设置刷新
- (void)setupRefresh {
    
    // header
    self.tableView.mj_header = [LINRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动设置透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 刚开始就进入下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    // footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - scrollView的代理方法
// 拖拽的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 清除内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
}

#pragma mark - 懒加载AFHTTPSessionManager
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 数据处理
- (LINTopicType)type {
    return 0;
}

- (NSString *)aparameter {
    // 判断帖子的参数，是新帖还是精华
    if ([self.parentViewController isKindOfClass:[LINNewViewController class]]) {
        return @"newlist";
    }
    
    return @"list";
}

// 发送请求给服务器，下拉刷新数据
- (void)loadNewTopics {
    
    // 解决同时下拉刷新和上拉刷新问题（取消上一次执行的任务，然后就进入错误处理）
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //[self footerEndRefreshing];
    
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aparameter;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary *  _Nullable responseObject) {
        // NSLog(@"%@", responseObject);
        [responseObject writeToFile:@"/Users/kingshaoshi/Desktop/topic_all.plist" atomically:YES];
        //  LINAFNWriteToPlist(123topic)
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数组
        self.topics = [LINTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 并非是取消任务导致的error，是其他问题导致的error
        if (error.code != NSURLErrorCancelled) {
            // 显示错误指示器
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 清空缓存cell高度字典
        
    }];
}

// 发送请求给服务器，上拉加载更多数据
- (void)loadMoreTopics {
    
    // 解决同时下拉刷新和上拉刷新问题（取消上一次执行的任务，然后就进入错误处理）
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //[self headerEndRefreshing];
    
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aparameter;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary *  _Nullable responseObject) {
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 将字典数组转换成模型数组
        NSMutableArray *moreTopics = [LINTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 并非是取消任务导致的error，是其他问题导致的error
        if (error.code != NSURLErrorCancelled) {
            // 显示错误指示器
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取模型
    LINTopic *topic = self.topics[indexPath.row];
    
    LINTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellID forIndexPath:indexPath];
    
    
    
    // 设置cell数据
    cell.topic = topic;
    
    return cell;
}

#pragma mark - tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 用模型属性保存cell的高度 (在模型中已经计算了cell的高度)
    
    LINTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LINComentViewController *commentVC = [[LINComentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}

@end
