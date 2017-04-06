//
//  LINComentViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/7.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINComentViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>


#import "LINTopicUser.h"
#import "LINTopicComment.h"
#import "LINTopicComentCell.h"
#import "LINTopic.h"
#import "LINTopicCell.h"
#import "LINCommentHeaderView.h"

static NSString * const commentCellID = @"comment";
static NSString * const headerID = @"header";
@interface LINComentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

// 网络请求管理者
@property (strong, nonatomic) AFHTTPSessionManager *manager;

// 暂时存储最热评论
@property (strong, nonatomic) LINTopicComment *topComment;

// 最热评论
@property (strong, nonatomic) NSArray *hotComments;
// 最新评论 （所有的评论数据）
@property (strong, nonatomic) NSMutableArray *lastestComments;


- (LINTopicComment *)selectedComment;
@end

@implementation LINComentViewController

#pragma makr - 懒加载网络请求管理者
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highlightedImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:nil action:nil];
    
    // 监听键盘的frame是否改变，键盘弹出和收回都会改变frame
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupTable];
    
    [self setupRefresh];
    
}

- (void)setupTable {
    // self.tableView.backgroundColor = LINCommentBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LINTopicComentCell class]) bundle:nil] forCellReuseIdentifier:commentCellID];
    [self.tableView registerClass:[LINCommentHeaderView class] forHeaderFooterViewReuseIdentifier:headerID];
    
    // 估算高度之类的
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 处理模型数据
    if (self.topic.topComment) {
        self.topComment = self.topic.topComment;
        self.topic.topComment = nil;
        // 相当于再计算一次cellHeight
        self.topic.cellHeight = 0;
    }
    
    // cell
    LINTopicCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LINTopicCell class]) owner:nil options:nil] lastObject];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, LINScreenW, self.topic.cellHeight);
    
    // 设置header
    UIView *header = [[UIView alloc] init];
    header.lin_height = self.topic.cellHeight ;
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
}

#pragma mark - 上拉刷新和下拉刷新
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
    // 进入页面，开启下拉刷新数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 监听UIKeyboardWillChangeFrameNotification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    // 工具条平移的距离 = 屏幕的高度 - 键盘的最终y值
    self.bottomSpace.constant = LINScreenH - [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - dealloc方法
- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的最热评论
    if (self.topComment) {
        self.topic.topComment = self.topComment;
        // 相当于再计算一次cellHeight
        self.topic.cellHeight = 0;
    }
}

#pragma mark - 加载评论数据
- (void)loadNewComments {
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"dataList";
    parameter[@"c"] = @"comment";
    parameter[@"data_id"] = self.topic.ID;
    parameter[@"hot"] = @1;
    
    // 发送请求
    LINWeakSelf;
    [self.manager GET:LINCommentURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        LINAFNWriteToPlist(@"newComments")
        
        // 意味着没有评论数据
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
            // 返回
            return ;
        }
        
        // 最热评论
        weakSelf.hotComments = [LINTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        weakSelf.lastestComments = [LINTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 判断评论数据是否已经完全加载
        if (self.lastestComments.count >= [responseObject[@"total"] integerValue]) {
            // 数据已经加载完毕，隐藏footer
            weakSelf.tableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments {
    // 取消之前的所有任务请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"a"] = @"dataList";
    parameter[@"c"] = @"comment";
    parameter[@"data_id"] = self.topic.ID;
    // 上一页最后一条评论的id
    parameter[@"lastcid"] = [self.lastestComments.lastObject ID];
    
    // 发送请求
    LINWeakSelf;
    [weakSelf.manager GET:LINCommentURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 增加最新评论
        NSArray *newComments = [LINTopicComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.lastestComments addObjectsFromArray:newComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
//        // 结束刷新
//        [weakSelf.tableView.mj_footer endRefreshing];
//        
//        // 判断数据是否加载完全
//        if (weakSelf.lastestComments.count >= [responseObject[@"total"] integerValue]) {
//            weakSelf.tableView.mj_footer.hidden = YES;
//        }
        
        // 判断评论数据是否加载完全
        if (weakSelf.lastestComments.count >= [responseObject[@"total"] integerValue]) {
            // 已经完全加载完毕
            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 应该还有下一页
            // 结束刷新（恢复的普通状态，仍旧可以继续刷新）
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hotComments.count) {
        return 2;
    } else if (self.lastestComments.count) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    } else {
        return self.lastestComments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LINTopicComentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    
    // 获得对应的评论数据
    NSArray *comments = [[NSArray alloc] init];
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    } else {
        comments = self.lastestComments;
    }
    
    // 传递模型给cell
    cell.topicComment = comments[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 结束编辑，辞去第一响应者，收回键盘
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LINCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    // 覆盖文字
    if (section == 0 && self.hotComments.count) {
        header.text = @"最热评论";
    } else {
        header.text = @"最新评论";
    }
    return header;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.hotComments.count) {
//        return @"最热评论";
//    } else {
//        return @"最新评论";
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 菜单控制器
    UIMenuController *menuC = [UIMenuController sharedMenuController];
    // 设置菜单内容
    UIMenuItem *dingItem = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)];
    UIMenuItem *warnItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)];
    menuC.menuItems = @[dingItem, replyItem, warnItem];
    
    // 显示位置
    CGRect rect = CGRectMake(0, cell.lin_height * 0.5, cell.lin_width, 1);
    [menuC setTargetRect:rect inView:cell];
    
    // 显示出来
    [menuC setMenuVisible:YES animated:YES];
}

#pragma mark - UIMenuController处理
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 如果控制器不是第一响应者，不能触发方法
    if (!self.isFirstResponder) { // 键盘是第一响应者，不能触发方法
        // 下面的好像没必要
//        if (action == @selector(ding:) || action == @selector(reply:) || action == @selector(warn:)) {
//            return NO;
//        }
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)ding:(UIMenuController *)menuC {
    NSLog(@"ding - %@ %@", self.selectedComment.user.username, self.selectedComment.content);
}

- (void)reply:(UIMenuController *)menuC {
    NSLog(@"reply - %@ %@", self.selectedComment.user.username, self.selectedComment.content);
}

- (void)warn:(UIMenuController *)menuC {
    NSLog(@"warn - %@ %@", self.selectedComment.user.username, self.selectedComment.content);
}

#pragma mark - 获得当前选中评论
- (LINTopicComment *)selectedComment {
    // 获得被选中的cell的行号
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    
    // 获得评论数据
    NSArray *comments = nil;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    } else {
        comments = self.lastestComments;
    }
    
    return comments[row];
}

@end
