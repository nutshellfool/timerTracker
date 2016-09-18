//
//  MBGLMainDBHelper.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/8.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBGLMainDBHelper.h"
#import "MBGLTimeRecordSQLiteTable.h"
#import "MBGLRecordInfoSQLiteTable.h"

@interface MBGLMainDBHelper ()

@property (nonatomic, strong) MBGLTimeRecordSQLiteTable *buildinTable;
@property (nonatomic, strong) MBGLRecordInfoSQLiteTable *recordInfoTable;

@end
@implementation MBGLMainDBHelper

- (NSArray *)allTables{
    NSMutableArray *tables = [NSMutableArray arrayWithCapacity:2];
    _buildinTable = [[MBGLTimeRecordSQLiteTable alloc] initWithTableName:@"time_record"];
    _recordInfoTable = [[MBGLRecordInfoSQLiteTable alloc] initWithTableName:@"record_info"];
    [tables addObject:_buildinTable];
    [tables addObject:_recordInfoTable];
    
    return tables;
}

- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime{
    return [_buildinTable insertTimeRecords:startTime withEndTime:endTime];
}

- (NSDictionary *) queryLatestRecord{
    return [_buildinTable queryLatestRecord];
}

- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval{
    return [_recordInfoTable insertRecordInfos:startTime withEndTime:endTime withInterval:interval withRecordInterval:recordInterval];
}

- (NSArray *) queryRecordInfos{
    return [_recordInfoTable queryRecordInfos];
}

- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId{
    return [_recordInfoTable deleteRecordByRecordId:rocordId];
}
- (BOOL) deleteAll{
    [_buildinTable deleteAllRecord];
    [_recordInfoTable deleteAllRecord];
    return YES;
}

@end
