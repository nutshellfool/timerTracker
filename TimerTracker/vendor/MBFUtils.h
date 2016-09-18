//
//  MBFUtils.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface MBFUtils : NSObject

+ (void)printDBError:(FMDatabase *)database;

+ (BOOL) isEmptyString:(NSString *)string;

@end
