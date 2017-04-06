//
//  LINSettingTableViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/6.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSettingTableViewController.h"
#import <SDImageCache.h>
#import "LINFileTool.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const ID = @"cell";
#define cachesPath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface LINSettingTableViewController ()

@property (assign, nonatomic) NSInteger totalSize;

@end

@implementation LINSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 注册重用cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸..."];
    
    // 进入控制器的时候就开始计算缓存
    // 获取文件夹尺寸
    // 文件夹非常小,如果我的文件非常大
    [LINFileTool getFileSize:cachesPath completion:^(NSInteger totalSize) {
        _totalSize = totalSize;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.textLabel.text = [self sizeStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 清空缓存,删除文件夹里的所有文件
    [LINFileTool removeDirectoryPath:cachesPath];
    _totalSize = 0;
    [self.tableView reloadData];
}

// 获取缓存尺寸字符串
- (NSString *)sizeStr {
    
    
    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"清除缓存";
    
    // MB KB B
    if (totalSize > 1000 * 1000) {
        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
    } else if (totalSize > 1000) {
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];
    } else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%.ldB)", sizeStr, (long)totalSize];
    }
    
    return sizeStr;
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
