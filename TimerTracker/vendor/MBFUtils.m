//
//  MBFUtils.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFUtils.h"

@implementation MBFUtils

+ (void)printDBError:(FMDatabase *)database
{
    NSLog(@" Database Error here : %d --> %@", [database lastErrorCode], [database lastErrorMessage]);
}


+ (BOOL) isEmptyString:(NSString *)string{
    if (!string || [string length] == 0){
        return YES;
    }
    return NO;
}

@end
