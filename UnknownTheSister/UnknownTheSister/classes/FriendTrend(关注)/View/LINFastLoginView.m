//
//  LINFastLoginView.m
//  UnknownTheSister
//
//  Created by king少诗 on 16/10/9.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINFastLoginView.h"

@implementation LINFastLoginView

+ (instancetype)FastLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:@"LINFastLoginView" owner:nil options:nil] firstObject];
}

@end
