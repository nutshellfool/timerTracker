//
//  MBGLBuildinDataSQLiteTable.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBGLTimeRecordSQLiteTable.h"
#import "FMDatabaseAdditions.h"

@implementation MBGLTimeRecordSQLiteTable

- (void)onCreate:(FMDatabase *)db{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE `time_records` ("];
    [sql appendString:@"`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"];
    [sql appendString:@"`start_time` TEXT,"];
    [sql appendString:@"`end_time` TEXT,"];
    [sql appendString:@"`note` TEXT"];
    [sql appendString:@");"];
    
    BOOL created = [db executeUpdate:sql];
    
    if (!created) {
        [self printDBError:db];
    }
    NSLog(@"creat table %@ ---> result %d", @"buildin", created);
}

- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime{
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO time_records (start_time, end_time) VALUES ('%@', '%@')", startTime, endTime];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
    
    return success;
}
- (NSDictionary *) queryLatestRecord{
    __block NSDictionary * records = @{};
    
    NSString *sql = [NSString stringWithFormat:@"SELECT start_time, end_time FROM time_records ORDER BY end_time DESC limit 1"];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *res = [db executeQuery:sql];
        if (res) {
            NSMutableDictionary *mutableResult = [[NSMutableDictionary alloc] init];
            while ([res next]) {
                NSString *startTime = [res stringForColumn:@"start_time"];
                NSString *endTime = [res stringForColumn:@"end_time"];
                if ( startTime && endTime ) {
                    [mutableResult setObject:startTime  forKey:@"startTime"];
                    [mutableResult setObject:endTime  forKey:@"endTime"];
                }
            }
            [res close];
            records = mutableResult;
        }
    }];
    
    return records;
}

- (BOOL)deleteAllRecord{
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM time_records "];
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
    
    return success;
}

//
//- (NSInteger)queryBuildinDataCount{
//    __block int count = 0;
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        count = [db intForQuery:@"SELECT COUNT(1) FROM `buildin`"];
//    }];
//    
//    return count;
//}
//
//- (NSArray *) queryBuildinCategoryDataBy:(NSInteger) gender withType:(NSInteger)dataType{
//    __block NSArray *result = nil;
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT distinct(category) FROM `buildin` where gender = %ld AND type = %ld and category %%30 =0 ORDER BY category",(long)gender, (long)dataType];
//        FMResultSet *res = [db executeQuery:sql];
//        if (res) {
//            NSMutableArray *mutableResult = [[NSMutableArray alloc] init];
//            while ([res next]) {
//                [mutableResult addObject:[NSNumber numberWithInt:[res intForColumn:@"category"]]];
//            }
//            [res close];
//            result = mutableResult;
//        }
//    }];
//    return result;
//}
//- (NSArray *) queryBuildinDataBy:(NSInteger) gender withType:(NSInteger)dataType withStandard:(NSInteger)standard{
//    __block NSArray *result = nil;
//    [self.databaseQueue inDatabase:^(FMDatabase *db) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT category,value FROM `buildin` where gender = %ld AND type = %ld and standard = %ld and category %%30=0 ORDER BY category  ",(long)gender, (long)dataType, (long)standard];
//        FMResultSet *res = [db executeQuery:sql];
//        if (res) {
//            NSMutableArray *mutableResult = [[NSMutableArray alloc] init];
//            NSNumber *category = nil;
//            NSNumber *categoryValue = nil;
//            while ([res next]) {
//                category = [NSNumber numberWithDouble:[res intForColumn:@"category"]];
//                categoryValue = [NSNumber numberWithDouble:[res doubleForColumn:@"value"]];
//                [mutableResult addObject:@{category:categoryValue}];
////                [mutableResult addObject:[NSNumber numberWithDouble:[res doubleForColumn:@"value"]]];
//                
//            }
//            [res close];
//            result = mutableResult;
//        }
//    }];
//    return result;
//}

@end
