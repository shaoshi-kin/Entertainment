//
//  LINCommentHeaderView.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINCommentHeaderView.h"

@interface LINCommentHeaderView ()

@property (weak, nonatomic) UILabel *label;


@end

@implementation LINCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // label
        UILabel *label = [[UILabel alloc] init];
        label.lin_x = LINSmallMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textColor = LINGrayColor(120);
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    
    self.label.text = text;
}


@end
