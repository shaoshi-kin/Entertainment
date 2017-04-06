//
//  LINFileTool.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/10/13.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINFileTool.h"

@implementation LINFileTool

+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion {
    
    
    
    // 获取文件管理者
    NSFileManager *manager = [[NSFileManager alloc] init];

    BOOL isDirectory;
    // 判断文件是否存在和判断是否为文件夹
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且文件夹要存在" userInfo:nil];
        [exception raise];
    }
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // NSFileManager
        // attributesOfItemAtPath:指定文件路径,就能获取文件属性
        // 把所有文件尺寸加起来
        
        // 获取文件夹下的所有子路径
        NSArray *subPaths = [manager subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件,跳过不计算
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否是文件夹
            BOOL isDirectory;
            // 判断文件是否存在和判断是否为文件夹
            BOOL isExist = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件属性
            NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
            
            // 获取文件尺寸
            NSInteger fileSize = [attrs fileSize];
            // 计算文件尺寸总和
            totalSize += fileSize;
            
        }
        
        // 计算完成后回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });

    });

}


+ (void)removeDirectoryPath:(NSString *)directoryPath {
    // 获取文件管理者
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    BOOL isDirectory;
    // 判断文件是否存在和判断是否为文件夹
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且文件夹要存在" userInfo:nil];
        [exception raise];
    }

    
    
    // 获取caches文件夹下的所有文件，不包括子路径下的文件
    NSArray *subPaths = [manager contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 删除路径
        [manager removeItemAtPath:filePath error:nil];
    }

}

@end
