//
//  LINMeTableViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINMeTableViewController.h"
#import "LINSettingTableViewController.h"
#import "LINSquareCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "LINSquareItem.h"
#import "LINWebViewController.h"


// 设置cell尺寸，四列，宽，高
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH  (LINScreenW - (cols - 1) * margin) / cols


@interface LINMeTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *squareItems;

// 引用UICollectionView属性，刷新集合视图
@property (weak, nonatomic) UICollectionView *collectionView;

@end

static NSString * const ID = @"collectionCell";
@implementation LINMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNavigationBar];
    
    // 设置tableView底部视图
    [self setupFooterView];
    
    // 展示footerView内容
    [self loadFooterViewData];
    
    // 处理cell间距，默认tableView分组样式，有头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = LINMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(LINMargin - 35, 0, 0, 0 );
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航条
- (void)setupNavigationBar {
    // 注意：把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    // 设置按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highlightedImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    // 夜间模式按钮
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    // 设置右边Items
    self.navigationItem.rightBarButtonItems = @[settingItem, nightItem];
    
    // 设置中间title
    self.navigationItem.title = @"我的";
}

// 点击设置按钮后调用
- (void)setting {
    LINSettingTableViewController *settingTVC = [[LINSettingTableViewController alloc] init];
    // 必须在跳转之前设置
    settingTVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingTVC animated:YES];
}


// 点击夜间模式按钮后调用
- (void)night:(UIButton *)button {
    button.selected = !button.selected;
}


#pragma mark - 设置tableFooterView
-(void) setupFooterView {
    // 集合视图
    // 1. 初始化要设置流水布局
    // 2. cell必须要注册
    // 3. cell必须自定义
    
    
    // 创建流水布局
    UICollectionViewFlowLayout *flowLayerout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的大小
    flowLayerout.itemSize = CGSizeMake(itemWH, itemWH);
    // 设置同一行cell之间的距离
    flowLayerout.minimumInteritemSpacing = margin;
    // 设置相邻行cell之间的距离
    flowLayerout.minimumLineSpacing = margin;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:flowLayerout];
    
    // 强引用，用来刷新视图
    self.collectionView = collectionView;
    
    collectionView.backgroundColor = self.tableView.backgroundColor;
    // 设置给footeView
    self.tableView.tableFooterView = collectionView;
    
    // 设置UICollectionViewDataSource的代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 设置UICollectionView不能滚动
    self.collectionView.scrollEnabled = NO;
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"LINSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionVIewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建网页视图控制器
    LINSquareItem *item = self.squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    
    LINWebViewController *webVC = [[LINWebViewController alloc] init];
    webVC.url = [NSURL URLWithString:item.url];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UICollectionVIewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LINSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}

#pragma mark - 展示footerView内容
- (void)loadFooterViewData {
    // 创建请求会话管理者
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    // 发送请求
    [manager GET:LINCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        // NSLog(@"%@", responseObject);
        // [responseObject writeToFile:@"/Users/kingshaoshi/Xcode/练习范例/UnknownTheSister/square.plist" atomically:YES];
        
        // 转换为字典数组
        NSArray *array = [responseObject objectForKey:@"square_list"];
        // 字典数组转换为模型数组
        self.squareItems = [LINSquareItem mj_objectArrayWithKeyValuesArray:array];
        
        // 设置UICollectionView，计算高度
        NSInteger count = self.squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        self.collectionView.lin_height = itemWH * rows + rows * margin;
        self.tableView.tableFooterView = self.collectionView;
        // self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));

        // 解决最后一行剩下的空格
        [self resloveLastLineItem];
        
        // 一定要刷新集合视图表格
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 解决最后一行剩下的空格
- (void)resloveLastLineItem {
    NSInteger count = self.squareItems.count;
    // 最后一行填充了多少个
    NSInteger lastLineItem = count % cols;
    if (lastLineItem) {
        // 最后一行剩余多少个
        lastLineItem = cols - lastLineItem;
        for (int i = 0; i < lastLineItem; i++) {
            LINSquareItem *item = [[LINSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self.tableView reloadData];
//}
//

@end
