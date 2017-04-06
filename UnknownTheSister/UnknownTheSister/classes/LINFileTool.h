//
//  LINFileTool.h
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/13.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINFileTool : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *   返回文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
