//
//  LINLoginAndRegisterView.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINLoginAndRegisterView.h"

@interface LINLoginAndRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;


@end

@implementation LINLoginAndRegisterView

+ (instancetype)loginView {
    return [[[NSBundle mainBundle] loadNibNamed:@"LINLoginAndRegisterView" owner:nil options:nil] firstObject];
}

+ (instancetype)registerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"LINLoginAndRegisterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = self.loginRegisterBtn.currentBackgroundImage;
    // 让按钮的背景图片不要被拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height];
    [self.loginRegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end
