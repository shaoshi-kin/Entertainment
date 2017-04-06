//
//  LINEssenceViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/5.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINEssenceViewController.h"
#import "LINTitleButton.h"
#import "LINAllTableViewController.h"
#import "LINVideoTableViewController.h"
#import "LINPictureTableViewController.h"
#import "LINVoiceTableViewController.h"
#import "LINWordTableViewController.h"

@interface LINEssenceViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

// 标题栏
@property (weak, nonatomic) UIView *titlesView;
// 保存上一次点击的标题按钮
@property (weak, nonatomic) LINTitleButton *previousPressedTitlesBtn;
// 标题下划线
@property (weak, nonatomic) UIView *titlesUnderline;

@end

@implementation LINEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化子控制器
    [self setupChildVCs];
    
    // 设置导航条
    [self setupNavigationBar];
    
    // 设置scrollView
    [self setupScrollView];
    
    // 设置标题栏
    [self setupTitlesView];
    
    // 添加第0个子控制器的view
    [self addChildViewControllerViewIntoScrollView:0];
}

#pragma mark - 初始化子控制器
- (void)setupChildVCs {
    [self addChildViewController:[[LINAllTableViewController alloc] init]];
    [self addChildViewController:[[LINVideoTableViewController alloc] init]];
    [self addChildViewController:[[LINVoiceTableViewController alloc] init]];
    [self addChildViewController:[[LINPictureTableViewController alloc] init]];
    [self addChildViewController:[[LINWordTableViewController alloc] init]];
}

#pragma mark - 设置导航条
- (void)setupNavigationBar {
    // 注意：把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highlightedImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // 设置右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highlightedImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // 设置中间titleView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.titleView = imageView;
}

- (void)game {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置scrollView
- (void)setupScrollView {
    // 不予许自动需改scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSUInteger count = [self.childViewControllers count];
    CGFloat scrollViewW = scrollView.lin_width;
    CGFloat scrollViewH = scrollView.lin_height;
    
    // 不在这里加载控制器，当使用的时候再加载
//    for (NSUInteger i = 0; i < count; i++) {
//        // 取出i位置的子控制器的view
//        UIView *childTVCView = self.childViewControllers[i].view;
//        childTVCView.frame = CGRectMake(scrollViewW * i, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childTVCView];
//    }
    
    scrollView.contentSize = CGSizeMake(scrollViewW *count, scrollViewH);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.lin_width;
    
    // 点击对应的标题按钮
    // LINTitleButton *btn = [self.titlesView viewWithTag:index];
    LINTitleButton *btn = self.titlesView.subviews[index];
    [self dealTitlesBtnClicked:btn];
}

#pragma mark - 设置标题栏
- (void)setupTitlesView {
    UIView *titlesView = [[UIView alloc] init];
    self.titlesView = titlesView;
    
    // 设置半透明色
    // titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    // titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    titlesView.frame = CGRectMake(0, LINNavMaxY, self.view.lin_width, LINTitlesViewH);
    [self.view addSubview:titlesView];
    
    // 设置标题栏按钮
    [self setupTitlesButton];
    
    // 设置标题下划线
    [self setupTitlesUnderline];
    
}

#pragma mark -设置标题栏按钮
- (void)setupTitlesButton {
    // 文字
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    
    // 设置标题按钮的大小
    CGFloat titlesBtnW = self.titlesView.lin_width / count;
    CGFloat titlesBtnH = self.titlesView.lin_height;
    
    // 创建五个按钮
    for (NSUInteger i = 0; i < 5; i++) {
        LINTitleButton *titlesBtn = [[LINTitleButton alloc] init];
        titlesBtn.tag = i;
        [titlesBtn addTarget:self action:@selector(titlesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titlesBtn];
        
        // 设置frame
        titlesBtn.frame = CGRectMake(i *titlesBtnW, 0, titlesBtnW, titlesBtnH);
        
        // 设置按钮文字，文字颜色
        [titlesBtn setTitle:titles[i] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 设置标题下划线
- (void)setupTitlesUnderline {
    // 标题按钮
    LINTitleButton *firstTitleBtn = self.titlesView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    self.titlesUnderline = titleUnderline;
    titleUnderline.lin_height = 2;
    titleUnderline.lin_y = self.titlesView.lin_height - titleUnderline.lin_height;
    titleUnderline.backgroundColor = [firstTitleBtn titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderline];
    
    
    // 切换按钮状态
    firstTitleBtn.selected = YES;
    self.previousPressedTitlesBtn = firstTitleBtn;
    
    // 让label根据文字内容计算尺寸
    [firstTitleBtn.titleLabel sizeToFit];
    self.titlesUnderline.lin_width = firstTitleBtn.titleLabel.lin_width + LINMargin;
    self.titlesUnderline.lin_centerX = firstTitleBtn.lin_centerX;
    
    
}

#pragma mark - titlesBtn的监听事件
- (void)titlesBtnClicked:(LINTitleButton *)titlesBtn {
    
    // 重复点击了标题按钮
    if (self.previousPressedTitlesBtn == titlesBtn) {
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LINTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 处理标题按钮的点击
    [self dealTitlesBtnClicked:titlesBtn];
}

- (void)dealTitlesBtnClicked:(LINTitleButton *)titlesBtn {
    self.previousPressedTitlesBtn.selected = NO;
    titlesBtn.selected = YES;
    self.previousPressedTitlesBtn = titlesBtn;
    
    // 标题下划线会跟随点击的按钮移动
    [UIView animateWithDuration:0.5 animations:^{
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.titlesUnderline.lin_width = titlesBtn.titleLabel.lin_width + LINMargin;
        self.titlesUnderline.lin_centerX = titlesBtn.lin_centerX;
        
        // 滚动scrollView
        // NSUInteger index = [self.titlesView.subviews indexOfObject:titlesBtn];
        // CGFloat offsetX = self.scrollView.lin_width * index;
        
        NSUInteger index = titlesBtn.tag;
        CGFloat offsetX = self.scrollView.lin_width * index;
        
        // 偏移的y保持原来的值
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        [self addChildViewControllerViewIntoScrollView:titlesBtn.tag];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES, 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        
        // 如果view还没有创建就不用去处理
        if (!childVC.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVC.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        scrollView.scrollsToTop = (i == titlesBtn.tag);
    }
}

#pragma mark - 添加子控制器的view到scrollView中
- (void)addChildViewControllerViewIntoScrollView:(NSUInteger)index {
    // 取出按钮索引对应的子控制器
    UIViewController *childVC = self.childViewControllers[index];
    
    // 如果view加载过就直接返回
    if (childVC.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *view = childVC.view;
    
    // 如果view加载过就直接返回
//    if (view.superview) return;
//    if (view.window) return;
    
    // 设置子控制器view的frame
    view.frame = CGRectMake(self.scrollView.lin_width * index, 0, self.scrollView.lin_width, self.scrollView.lin_height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:view];
}



@end
