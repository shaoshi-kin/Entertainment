//
//  LINPostWordToolBar.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/15.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINPostWordToolBar.h"
#import "LINAddTagViewController.h"
#import "LINNavigationViewController.h"

@interface LINPostWordToolBar ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 所有的标签label */
@property (strong, nonatomic) NSMutableArray *tagLabels;
/** 加号按钮 */
@property (weak, nonatomic) UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end


@implementation LINPostWordToolBar

- (NSMutableArray *)tagLabels {
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 加号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认传递连个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}


/**
 加号按钮的触发方法
 */
- (void)addButtonClicked {
    LINWeakSelf;
    LINAddTagViewController *addTagVC = [[LINAddTagViewController alloc] init];
    addTagVC.getTagsBlock = ^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    };
    
    // 传递给下一个界面
    addTagVC.tags = [self.tagLabels valueForKeyPath:@"text"];
    LINNavigationViewController *navVC = [[LINNavigationViewController alloc] initWithRootViewController:addTagVC];
    // 拿到“窗口跟控制器”曾经model出来的“发表文字所在的导航控制器”
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    [vc presentViewController:navVC animated:YES completion:nil];
    
}

/**
 创建标签label，默认传递连个标签

 @param tags 传递的标签数组，里面存放标签名字
 */
- (void)createTagLabels:(NSArray *)tags {
    // 让self.tagLabels数组中的所有对象执行removeFromSuperView方法，从父控件中移除控件
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 移除self.tagLabels数组中的所有对象
    [self.tagLabels removeAllObjects];
    
    // 所有的标签label
    for (int i = 0; i < tags.count; i++) {
        // 创建label
        UILabel *newTagLabel = [[UILabel alloc] init];
        newTagLabel.text = tags[i];
        newTagLabel.font = [UIFont systemFontOfSize:14];
        newTagLabel.backgroundColor = LINTagBgColor;
        newTagLabel.textColor = [UIColor whiteColor];
        newTagLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:newTagLabel];
        [self.tagLabels addObject:newTagLabel];
        
        // 微调尺寸
        [newTagLabel sizeToFit];
        newTagLabel.lin_height = LINTagH;
        newTagLabel.lin_width += 2 * LINSmallMargin;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 所有的标签label
    for (int i = 0; i < self.tagLabels.count; i++) {
        // 创建label
        UILabel *newTagLabel = self.tagLabels[i];
        
        // label位置
        if (i == 0) {
            newTagLabel.lin_x = 0;
            newTagLabel.lin_y = 0;
        } else {
            // 上一个标签
            UILabel *previousTagLabel = self.tagLabels[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(previousTagLabel.frame) + LINSmallMargin;
            // 上一个标签右边剩余的位置
            CGFloat rightWidth = LINScreenW - leftWidth;
            if (rightWidth > newTagLabel.lin_width) { // 如果上一个标签右边剩余的位置的宽度能放新的标签
                newTagLabel.lin_x = leftWidth;
                newTagLabel.lin_y = previousTagLabel.lin_y;
            } else { // 宽度不足以放，下一行开始放
                newTagLabel.lin_x = 0;
                newTagLabel.lin_y = CGRectGetMaxY(previousTagLabel.frame) + LINSmallMargin;
            }
        }
    }
    
    // 加号按钮
    UILabel *lastTagLabel = self.tagLabels.lastObject;
    if (lastTagLabel) {
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + LINSmallMargin;
        CGFloat rightWidth = LINScreenW - leftWidth;
        if (rightWidth > self.addButton.lin_width) {
            self.addButton.lin_x = leftWidth;
            self.addButton.lin_y = lastTagLabel.lin_y;
        } else {
            self.addButton.lin_x = 0;
            self.addButton.lin_y = CGRectGetMaxY(lastTagLabel.frame) + LINSmallMargin;
        }
    } else {
        self.addButton.lin_x = 0;
        self.addButton.lin_y = 0;
    }
    
    // 计算工具条的高度
    self.topViewHeight.constant = CGRectGetMaxY(self.addButton.frame);
    CGFloat oldHeight = self.lin_height;
    self.lin_height = self.topViewHeight.constant + self.bottomView.lin_height + LINSmallMargin;
    // 调整好高度后，调整y值
    self.lin_y += oldHeight - self.lin_height;
}



@end
