//
//  LINWebViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/12.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINWebViewController.h"
#import <WebKit/WKWebView.h>

@interface LINWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *containView;
@property  (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UIProgressView *pregressView;




@end

@implementation LINWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 创建webView
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.containView addSubview:webView];
    // 展示网页
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:URLRequest];
    
    // 监听属性改变
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

// 移除观察者
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

// 监听的属性改变时候调用这个方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.leftItem.enabled = self.webView.canGoBack;
    self.rightItem.enabled = self.webView.canGoForward;
    
    if (self.webView.canGoBack) {
        self.leftItem.image = [UIImage imageNamed:@"leftBack1"];
    } else {
        self.leftItem.image = [UIImage imageNamed:@"leftBack"];
    }
    
    if (self.webView.canGoForward) {
        self.rightItem.image = [UIImage imageNamed:@"rightForword1"];
    } else {
        self.rightItem.image = [UIImage imageNamed:@"rightForword"];
    }
    
    self.title = self.webView.title;
    self.pregressView.progress = self.webView.estimatedProgress;
    self.pregressView.hidden = self.webView.estimatedProgress >= 1;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.containView.bounds;
    
    self.webView.lin_height -= 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 后退，前进，刷新
- (IBAction)leftItemClicked:(id)sender {
    [self.webView goBack];
}
- (IBAction)rightItemClicked:(id)sender {
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
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
