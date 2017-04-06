//
//  LINSquareCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/11.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINSquareCell.h"
#import "LINSquareItem.h"
#import <UIImageView+WebCache.h>

@interface LINSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;


@end

@implementation LINSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(LINSquareItem *)item {
    _item = item;
    
    self.nameLbl.text = item.name;
    
    // 图片来自于服务器
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:item.icon]];
}

@end
