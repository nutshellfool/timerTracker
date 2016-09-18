//
//  MBFFileUtils.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/8.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBFFileUtils : NSObject

+ (NSString *)docRootPath;
+ (BOOL)isFileExistForPath:(NSString *)path isDirectory:(BOOL) isDirectory;
@end
