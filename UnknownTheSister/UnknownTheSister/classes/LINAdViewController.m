//
//  LINAdViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/7.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINAdViewController.h"
#import "LINAdItem.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "LINTabBarController.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface LINAdViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@property (weak, nonatomic) UIImageView *adView;
@property (strong, nonatomic) LINAdItem *item;
@property (weak, nonatomic) NSTimer *timer;

@end

@implementation LINAdViewController

#pragma mark - 点击跳转按钮触发的方法
- (IBAction)jumpBtnClicked:(id)sender {
    // 销毁广告界面，进入主框架界面
    LINTabBarController *tabBarVC = [[LINTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
    
    // 销毁定时器
    [self.timer invalidate];
    
}

#pragma mark - 懒加载adView
- (UIImageView *)adView {
    if (_adView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.adContainView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        _adView = imageView;
    }
    return _adView;
}

// 点击广告图片触发的方法
- (void)tap {
    NSURL *url = [NSURL URLWithString:self.item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}

#pragma mark - viewDidLoad方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 裁剪按钮
    self.jumpBtn.layer.cornerRadius = 5;
    self.jumpBtn.layer.masksToBounds = YES;
    
    // 设置启动图片
    [self setupLaunchImage];
    
    // 加载广告数据 => 拿到活时间 => 服务器 => 查看接口文档 1.判断接口对不对 2.解析数据(w_picurl,ori_curl:跳转到广告界面,w,h) => 请求数据(AFN)
    [self loadAdData];
    
    // 创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

- (void)timeChange {
    // 倒计时为3秒
    static int i = 5;
    
    if (i == 0) {
        [self jumpBtnClicked:nil];
    }
    // 每调用一次，时间减少一秒
    i--;
    
    NSString *jumpTitle = [NSString stringWithFormat:@"跳过 %d ", i];
    [self.jumpBtn setTitle:jumpTitle forState:UIControlStateNormal];
    
}

/*
 http://mobads.baidu.com/cpro/ui/mads.php
 code2
 phcqnauguhykfmrquanhmgn_iaubthfqmgksuarhiwdgulpxnz3vndtkqw08nau_i1y1p1rhmhwz5hb8nbul5hdknwrhta_qmvqvqhgguhi_py4mqhf1tvchmgky5h6hmypw5rfrhzuet1dgulnhuan85hchuy7s5hdhiywgujy3p1n3mwb1pvdlnvf-pyf4mhr4nyrvmwpbmhwbpjclpyfspht3uwm4fmplphykfh7sta-b5yrzpj6spvrdfhpdtwysfmkzuykemyfqnauguau95rnsnbfknbm1qhnkww6vpjujnbdkfwd1qhnsnbrsnhwkfywawiu9mlfqhbd_h70htv6qnhn1pauvmynqnjclnj0lnj0lnj0lnj0lnj0hthyqniuvujykfhkc5hrvnb3dfh7spyfqnw0srj64nbu9tjysfmub5hdhtzfeujdztlk_mgpcfmp85rnsnbfknbm1qhnkww6vpjujnbdkfwd1qhnsnbrsnhwkfywawiubnhfdnjd4rjnvpwykfh7stzu-twy1qw68nbuwuhydnhchiayqphdzfhqsmypgizbqniuythuytjd1uavxnz3vnzu9ijyzfh6qp1rsfmws5y-fpaq8uht_nbuymycqnau1ijykpjrsnhb3n1mvnhdkqwd4niuvmybqniu1uy3qwd-hqdfkhakhhnn_hr7fq7udq7pchzkhir3_ryqnqd7jfzkpirn_wdkhqdp5hikpfrb_fnc_nbwpqddrhzkdinchtvww5hnvpj0zqwndnhrvnbsdpwb4ri3kpw0kphmhmlnqph6lp1ndm1-wpydvnhkbraw9nju9phihmh9wmh6zrjrhtv7_5iu85hdhtvd15hdhtltqp1rsfh4etjyypw0spzuvuyyqn1mynjc8nwbvrjtdqjrvrhb4qwdvnjddpbuk5yrzpj6spvrdgvpstbu_my4btvp9tarqnam
 */
- (void)loadAdData {
    // 创建请求会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //发送请求
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        // 请求数据， 解析数据（写成plist文件）， 设计模型， 字典转模型， 展示数据
        // 将返回的数据（写成plist文件），这样我我们就可以看得懂里面的数据
        [responseObject writeToFile:@"/Users/kingshaoshi/Desktop/ad.plist" atomically:YES];
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        
        // 字典转模型
        self.item = [LINAdItem mj_objectWithKeyValues:adDict];
        
        // 创建UIImageView展示图片
        CGFloat h = LINScreenW / self.item.w *self.item.h;
        self.adView.frame = CGRectMake(0, 0, LINScreenW, h);
        
        // 加载广告网页
        [self.adView sd_setImageWithURL:[NSURL URLWithString:self.item.w_picurl]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // NSLog(@"%@", error);
    }];
}

#pragma mark - 设置启动图片
- (void)setupLaunchImage {
    if (iphone6Plus) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iphone6) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iphone5) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    } else if (iphone4) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
