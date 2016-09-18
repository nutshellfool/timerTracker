//
//  MBGLMainDBHelper.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/8.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFSQLiteOpenHelper.h"
//#import "MBGLBabySQLiteTable.h"
//#import "MBGLBabyDataSQLiteTable.h"

@interface MBGLMainDBHelper : MBFSQLiteOpenHelper

- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime;
- (NSDictionary *) queryLatestRecord;
- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval;
- (NSArray *) queryRecordInfos;
- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId;
- (BOOL) deleteAll;

//- (void) insertBuildinData;
//- (BOOL) isBuildinDataEmpty;
//- (NSArray *) queryBuildinCategoryDataBy:(NSInteger) gender withType:(NSInteger)dataType;
//- (NSArray *) queryBuildinDataBy:(NSInteger) gender withType:(NSInteger)dataType withStandard:(NSInteger)standard;


//- (void) insertBabyData:(MBGLBabyGrowthData *)data;
//- (NSArray<MBGLBabyGrowthData*> *) queryBabyData:(NSString *)babyId;
//- (NSArray *) queryBabyDataByBabyId:(NSInteger)babyId withType:(NSInteger)dataType;
//- (void) addBabyByUser:(NSString *)userId withBaby:(MBGLBabyModel *)babyModel;
//- (MBGLBabyModel *) getBabyByBabyId:(NSString *)babyId;


@end
