//
//  LINAddTagViewController.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/16.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINAddTagViewController.h"
#import "LINTagButton.h"
#import "LINTagTextField.h"
#import <SVProgressHUD.h>


@interface LINAddTagViewController () <UITextFieldDelegate>

/** 用来容纳所有按钮和文本框 */
@property (weak, nonatomic) UIView *contentView;
/** 文本框 */
@property (weak, nonatomic) LINTagTextField *textField;
/** 提醒按钮 */
@property (weak, nonatomic) UIButton *tipButton;
/** 存放所有的标签按钮 */
@property (strong, nonatomic) NSMutableArray *tagButtons;

@end

@implementation LINAddTagViewController

#pragma mark - 懒加载
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        // 创建一个提醒按钮
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipButton addTarget:self action:@selector(tipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        tipButton.lin_width = self.contentView.lin_width;
        tipButton.lin_height = LINTagH;
        tipButton.lin_x = 0;
        tipButton.backgroundColor = LINTagBgColor;
        tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        // 水平排布控件的内容，默认是UIControlContentHorizontalAlignmentLeft
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        tipButton.contentEdgeInsets = UIEdgeInsetsMake(0, LINSmallMargin, 0, 0); // 上左下右
        [self.contentView addSubview:tipButton];
        _tipButton = tipButton;
    }
    return _tipButton;
}

#pragma mark - viewDidLoad方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNavigationItem];
    
    // 设置contentView
    [self setupContentView];
    
    // 设置输入文本框
    [self setupTextField];
    
    // 设置标签按钮,先将上一个界面的标签显示出来
    [self setupTagButton];
}

/**
 设置导航栏
 */
- (void)setupNavigationItem {
    // 标题
    self.title = @"添加标签";
    // 左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    // 右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

/**
 设置contentView
 */
- (void)setupContentView {
    UIView *contentView = [[UIView alloc] init];
    contentView.lin_x = LINSmallMargin;
    contentView.lin_y = LINNavMaxY + LINSmallMargin;
    contentView.lin_width = self.view.lin_width - 2 * LINSmallMargin;
    contentView.lin_height = self.view.lin_height;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

/**
 设置输入文本框
 */
- (void)setupTextField {
    LINWeakSelf;
    
    LINTagTextField *textField = [[LINTagTextField alloc] init];
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    textField.lin_width = self.contentView.lin_width;
    textField.lin_height = LINTagH;
    // 设置占位文字
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    textField.placeHolderColor = [UIColor grayColor];
    textField.delegate = self;
    [self.contentView addSubview:textField];
    [textField becomeFirstResponder];
    // 刷新的前提：这个控件已经被添加到父控件中
    [textField layoutIfNeeded];
    self.textField = textField;
    
    // 设置点击删除键需要执行的操作
    textField.deleteBackwardOperation = ^{
        // 判断文本框是否有文字
        if (weakSelf.textField.hasText || weakSelf.tagButtons.count == 0) return ;
        
        // 点击了最后一个标签按钮（删掉最后一个标签按钮）
        [self tagButtonClicked:weakSelf.tagButtons.lastObject];
    };
    
    // stackoverflow
}

/**
 设置标签按钮,先将上一个界面的标签显示出来
 */
- (void)setupTagButton {
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self tipButtonClicked];
    }
}

#pragma mark - 监听

/**
 监听textField文字的改变
 */
- (void)textDidChange {
    // 设置提醒按钮的属性内容
    if (self.textField.hasText) {
        NSString *text = self.textField.text;
        NSString *lastChar = [text substringFromIndex:text.length - 1];
        // 如果最后一个输入字符是逗号，把逗号前的字符显示到一个新的标签按钮
        if ([lastChar isEqualToString:@","] || [lastChar isEqualToString:@"，"]) {
            // 去掉文本框的逗号
            [self.textField deleteBackward];
            
            // 点击提醒按钮
            [self tipButtonClicked];
        } else { // 最后一个输入的字符不是逗号
            // 排布文本框
            [self setupTextFieldFrame];
            
            self.tipButton.hidden = NO;
            [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签：%@", text] forState:UIControlStateNormal];
        }
    } else {
        // textField没有文字输入，隐藏提醒按钮
        self.tipButton.hidden = YES;
    }
}


/**
 点击了提醒按钮
 */
- (void)tipButtonClicked {
    // 文本框没有文字，直接返回
    if (self.textField.hasText == 0) return;
    
    // 最多只能添加5个标签
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showWithStatus:@"最多只能添加5个标签"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        // 三秒后弹框消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        return;
    }
    
    // 创建一个标签按钮
    LINTagButton *tagButton = [LINTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(tagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:tagButton];
    
    // 设置位置，参照最后一个标签按钮
    [self setupTagButtonFrame:tagButton referenceTagButton:self.tagButtons.lastObject];
    
    // 添加到数组中
    [self.tagButtons addObject:tagButton];
    
    // 排布文本框
    self.textField.text = nil;
    [self setupTextFieldFrame];
    
    // 隐藏提醒按钮
    self.tipButton.hidden = YES;
}

#pragma mark - 导航栏按钮触发的方法
- (void)cancel {
    // 关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    // 1.传递数据回到上一个界面
    
//    NSMutableArray *tags = [NSMutableArray array];
//    for (LINTagButton *tagButton in self.tagButtons) {
//        [tags addObject:tagButton.currentTitle];
//    }
    
    // 将self.tagButtons中存放的所有对象的currentTitle属性值取出来，放到一个新的数组，并返回
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.getTagsBlock ? : self.getTagsBlock(tags);
    
    // 2.关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 点击了标签按钮

 @param tagButton 点击的那个标签按钮
 */
- (void)tagButtonClicked:(LINTagButton *)tagButton {
    // 即将被删除的标签按钮的索引
    NSUInteger index = [self.tagButtons indexOfObject:tagButton];
    
    // 删除按钮
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 处理后面的标签按钮
    for (NSUInteger i = index; i < self.tagButtons.count; i++) {
        LINTagButton *button = self.tagButtons[i];
        // 如果i不为0，就参照上一个标签按钮
        LINTagButton *previousTagButton = (i == 0) ? nil : self.tagButtons[i - 1];
        // 重新排布标签按钮位置
        [self setupTagButtonFrame:button referenceTagButton:previousTagButton];
    }
    
    // 排布文本框
    [self setupTextFieldFrame];
}

#pragma mark - 设置控件的frame

- (void)setupTagButtonFrame:(LINTagButton *)tagButton referenceTagButton:(LINTagButton *)referenceTagButton {
    // 没有参照按钮（tagButton是第一个标签按钮）
    if (referenceTagButton == nil) {
        tagButton.lin_x = 0;
        tagButton.lin_y = 0;
        return;
    }
    
    // tagButton不是第一个标签按钮
    CGFloat leftWidth = CGRectGetMaxX(referenceTagButton.frame) + LINSmallMargin;
    CGFloat rightWidth = LINScreenW - leftWidth;
    if (rightWidth >= tagButton.lin_width) { // 跟上一个标签在同一行
        tagButton.lin_x = leftWidth;
        tagButton.lin_y = referenceTagButton.lin_y;
    } else { // 在下一行
        tagButton.lin_x = 0;
        tagButton.lin_y = CGRectGetMaxY(referenceTagButton.frame) + LINSmallMargin;
    }
}

- (void)setupTextFieldFrame {
    // 没有考虑文本框的宽度超过屏幕的情况，这是我自己测试出来的
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.textField.font;
    CGFloat textW = [self.textField.text sizeWithAttributes:attrs].width;
    textW = MAX(100, textW);
    
    LINTagButton *lastTagButton = self.tagButtons.lastObject;
    if (lastTagButton == nil) {
        self.textField.lin_x = 0;
        self.textField.lin_y = 0;
    } else {
        CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + LINSmallMargin;
        CGFloat rightWidth = LINScreenW - leftWidth;
        if (rightWidth > textW) { // 有足够的位置，在同一行
            self.textField.lin_x = leftWidth;
            self.textField.lin_y = lastTagButton.lin_y;
        } else { // 换行
            self.textField.lin_x = 0;
            self.textField.lin_y = CGRectGetMaxY(lastTagButton.frame) + LINSmallMargin;
        }
    }
    
    // 排布提醒按钮
    self.tipButton.lin_y = CGRectGetMaxY(self.textField.frame) + LINSmallMargin;
}

#pragma mark - UITextFieldDelegate

/**
 点击右下角return按钮就会调用这个方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tipButtonClicked];
    
    return YES;
}

@end
