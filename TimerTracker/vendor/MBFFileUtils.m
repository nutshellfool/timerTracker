//
//  MBFFileUtils.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/8.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFFileUtils.h"

@implementation MBFFileUtils

+ (NSString *)docRootPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (BOOL)isFileExistForPath:(NSString *)path isDirectory:(BOOL) isDirectory
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

@end
