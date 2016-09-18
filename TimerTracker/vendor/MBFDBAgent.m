//
//  MBFDBAgent.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFDBAgent.h"
#import "MBGLMainDBHelper.h"
@interface MBFDBAgent ()

@property (nonatomic, strong) NSObject *buildinLock;
@property (nonatomic, strong) MBGLMainDBHelper *mainDB;

- (void)initDataBases;

- (void)initSyncLock;

@end
@implementation MBFDBAgent

+ (instancetype) sharedInstance{
    static MBFDBAgent *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MBFDBAgent alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        // custom init here
        [self initSyncLock];
        [self initDataBases];
    }
    
    return self;
}

- (void)initSyncLock
{
    //        self.dbManagerLock = [[NSObject alloc] init];
    _buildinLock = [[NSObject alloc] init];
}

- (void)initDataBases
{
    self.mainDB = [[MBGLMainDBHelper alloc] initWithName:@"timertracker.db" withVersion:1];
    [self.mainDB getDatabase];
}

- (BOOL) insertTimeRecords:(NSString *) startTime withEndTime:(NSString *) endTime{
    @synchronized (_buildinLock) {
        return [self.mainDB insertTimeRecords:startTime withEndTime:endTime];
    }
}

- (NSDictionary *) queryLatestRecord{
    return [self.mainDB queryLatestRecord];
}

- (BOOL) insertRecordInfos:(NSString *) startTime withEndTime:(NSString *) endTime withInterval:(NSString *)interval withRecordInterval: (NSString *) recordInterval{
    @synchronized (_buildinLock) {
        return [self.mainDB insertRecordInfos:startTime withEndTime:endTime withInterval:interval withRecordInterval:recordInterval];
    }
}

- (NSArray *) queryRecordInfos{
    return [self.mainDB queryRecordInfos];
}

- (BOOL) deleteRecordByRecordId:(NSNumber *)rocordId{
    return [self.mainDB deleteRecordByRecordId:rocordId];
}
- (BOOL) deleteAll{
    return [self.mainDB deleteAll];
}


//- (void) insertBuildinData{
//    @synchronized (_buildinLock) {
//        BOOL isEmpty = [self.mainDB isBuildinDataEmpty];
//        if (isEmpty) {
//            [self.mainDB insertBuildinData];
//        }
//    }
//}
//
//- (NSArray *) queryBuildinCategoryDataBy:(NSInteger) gender withType:(NSInteger)dataType{
//    NSArray *result = [self.mainDB queryBuildinCategoryDataBy:gender withType:dataType];
//    return result;
//}
//
//- (NSArray *) queryBuildinDataBy:(NSInteger) gender withType:(NSInteger)dataType withStandard:(NSInteger)standard{
//    NSArray *result = [self.mainDB queryBuildinDataBy:gender withType:dataType withStandard:standard];
//    return result;
//}
//
//- (void) insertBabyData:(MBGLBabyGrowthData *)data{
//    @synchronized (_buildinLock) {
//        [self.mainDB insertBabyData:data];
//    }
//}
//- (NSArray<MBGLBabyGrowthData*> *) queryBabyData:(NSString *)babyId{
//    return [self.mainDB queryBabyData:babyId];
//}
//- (void) addBabyByUser:(NSString *)userId withBaby:(MBGLBabyModel *)babyModel{
//    @synchronized (_buildinLock) {
//        [self.mainDB addBabyByUser:userId withBaby:babyModel];
//    }
//}
//- (MBGLBabyModel *) getBabyByBabyId:(NSString *)babyId{
//    return [self.mainDB getBabyByBabyId:babyId];
//}
//
//- (NSArray *) queryBabyDataByBabyId:(NSInteger)babyId withType:(NSInteger)dataType{
//    return [self.mainDB queryBabyDataByBabyId:babyId withType:dataType];
//}

@end
