//
//  MBGLRecordInfoSQLiteTable.m
//  TimerTracker
//
//  Created by Richard Li on 16/9/12.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBGLRecordInfoSQLiteTable.h"

@implementation MBGLRecordInfoSQLiteTable

- (void)onCreate:(FMDatabase *)db{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE `record_infos` ("];
    [sql appendString:@"`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"];
    [sql appendString:@"`start_time` TEXT,"];
    [sql appendString:@"`end_time` TEXT,"];
    [sql appendString:@"`interval_time` TEXT,"];
    [sql appendString:@"`record_interval` TEXT,"];
    [sql appendString:@"`status` INTEGER DEFAULT 0,"];
    [sql appendString:@"`note` TEXT"];
    [sql appendString:@");"];
    
    BOOL created = [db executeUpdate:sql];
    
    if (!created) {
        [self printDBError:db];
    }
    NSLog(@"creat table %@ ---> result %d", @"buildin", created);
}

- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval{
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO record_infos (start_time, end_time, interval_time, record_interval) VALUES ('%@', '%@', '%@', '%@')", startTime, endTime, interval, recordInterval];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
    
    return success;
}

-(NSArray *)queryRecordInfos{
    __block NSArray *result = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT `id`,start_time, end_time, interval_time,record_interval FROM `record_infos` where status = 0 ORDER BY start_time DESC"];
        FMResultSet *res = [db executeQuery:sql];
        if (res) {
            NSMutableArray *mutableResult = [[NSMutableArray alloc] init];
            while ([res next]) {
                
                
                [mutableResult addObject:@{@"startTime":[res stringForColumn:@"start_time"], @"endTime":[res stringForColumn:@"end_time"], @"intervalTime":[res stringForColumn:@"interval_time"], @"recordInterval":[res stringForColumn:@"record_interval"], @"id":[NSNumber numberWithInt:[res intForColumn:@"id"]]}];
            }
            [res close];
            result = mutableResult;
        }
    }];
    return result;
}

- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId{
        __block BOOL success = NO;
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM record_infos where `id` = %d", rocordId.intValue];
        
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:sql];
        }];
        
        return success;
}

- (BOOL)deleteAllRecord{
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE * FROM time_records "];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
    
    return success;
}

@end
