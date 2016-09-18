//
//  MBGLBuildinDataSQLiteTable.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFSQLiteBaseTable.h"

@interface MBGLTimeRecordSQLiteTable : MBFSQLiteBaseTable

- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime;
- (NSDictionary *) queryLatestRecord;
- (BOOL) deleteAllRecord;

//- (NSInteger) queryBuildinDataCount;
//
//- (NSArray *) queryBuildinCategoryDataBy:(NSInteger) gender withType:(NSInteger)dataType;
//- (NSArray *) queryBuildinDataBy:(NSInteger) gender withType:(NSInteger)dataType withStandard:(NSInteger)standard;

@end
