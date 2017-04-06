//
//  LINUser.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/29.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINUser : NSObject

/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;
/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;


@end
