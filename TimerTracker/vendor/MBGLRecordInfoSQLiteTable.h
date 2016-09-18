//
//  MBGLRecordInfoSQLiteTable.h
//  TimerTracker
//
//  Created by Richard Li on 16/9/12.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFSQLiteBaseTable.h"

@interface MBGLRecordInfoSQLiteTable : MBFSQLiteBaseTable

- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval;
- (NSArray *) queryRecordInfos;

- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId;
- (BOOL) deleteAllRecord;

@end
