//
//  LINSubTagViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/8.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "LINSubTagItem.h"
#import "LINSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LINRefreshHeader.h"

static NSString * const CellID = @"Cell";

@interface LINSubTagViewController ()

@property (strong, nonatomic) NSMutableArray *subTag;
@property (weak, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation LINSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载订阅标签数据
    [self loadData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LINSubTagCell" bundle:nil] forCellReuseIdentifier:CellID];
    
    // 设置控制器的标题
    self.title = @"推荐标签";
    
    // 方法1“：清空tableView分割线内边距，清空cell的约束边缘(iOS7之后才有)
    // self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // 方法2：
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1.0];
    
    // 创建指示器，告诉用户正在加载数据
    [SVProgressHUD showWithStatus:@"正在加载ing..."];
    
    // 下拉刷新
    [self setupRefresh];
    
}

- (void)setupRefresh {
    
    self.tableView.mj_header = [LINRefreshHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"刷新成功");
            [self.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 销毁指示器
    [SVProgressHUD dismiss];
    
    // 取消之前的网络数据请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 请求数据
- (void)loadData {
    // 创建请求会话管理者
    self.manager = [AFHTTPSessionManager manager];
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"c"] = @"topic";
    parameters[@"action"] = @"sub";
    // 发送请求
    [self.manager GET:LINCommentURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableArray * _Nullable responseObject) {
        
        // 请求数据成功，销毁指示器
        [SVProgressHUD dismiss];
        
        // NSLog(@"%@", responseObject);
        // [responseObject writeToFile:@"/Users/kingshaoshi/Xcode/练习范例/UnknownTheSister/subTag.plist" atomically:YES];
        // 将字典数组转换成模型数组
        self.subTag = [LINSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 如果是取消了任务，就不算请求失败，直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        // 请求超时
        if (error.code == NSURLErrorTimedOut) {
            [SVProgressHUD showErrorWithStatus:@"加载标签数据超时，请稍后再试！"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTag.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LINSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    // 获取模型数据
    LINSubTagItem *item = self.subTag[indexPath.row];
    cell.item =item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
