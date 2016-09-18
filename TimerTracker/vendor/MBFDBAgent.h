//
//  MBFDBAgent.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MBGLBabyGrowthData.h"
//#import "MBGLBabyModel.h"

@interface MBFDBAgent : NSObject

+(instancetype)sharedInstance;


- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime;
- (NSDictionary *) queryLatestRecord;
- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval;
- (NSArray *) queryRecordInfos;
- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId;
- (BOOL) deleteAll;

//- (void) insertBuildinData;
//- (NSArray *) queryBuildinCategoryDataBy:(NSInteger) gender withType:(NSInteger)dataType;
//- (NSArray *) queryBuildinDataBy:(NSInteger) gender withType:(NSInteger)dataType withStandard:(NSInteger)standard;

//- (void) insertBabyData:(MBGLBabyGrowthData *)data;
//- (NSArray<MBGLBabyGrowthData*> *) queryBabyData:(NSString *)babyId;
//- (NSArray *) queryBabyDataByBabyId:(NSInteger)babyId withType:(NSInteger)dataType;
//- (void) addBabyByUser:(NSString *)userId withBaby:(MBGLBabyModel *)babyModel;
//- (MBGLBabyModel *) getBabyByBabyId:(NSString *)babyId;


@end
