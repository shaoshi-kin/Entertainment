//
//  MJExtensionConfig.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/7.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension.h>

#import "LINTopic.h"
#import "LINCategory.h"
#import "LINTopicComment.h"

@implementation MJExtensionConfig


+ (void)load {
    
    
    [LINTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id",
                 @"topComment" : @"top_cmt[0]"};
    }];
    
    [LINCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    [LINTopicComment mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
