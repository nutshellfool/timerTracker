//
//  MBFSQLiteBaseTable.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFSQLiteBaseTable.h"
#import "MBFUtils.h"

@implementation MBFSQLiteBaseTable
#pragma mark - init

- (id)init
{
    NSAssert(NO, @"Can not init SQLiteBaseTable in this way, use initWithTableName");
    return [super init];
}

- (id)initWithTableName:(NSString *)tableName
{
    self = [super init];
    if (self) {
        self.tableName = tableName;
    }
    
    return self;
}

- (void)printDBError:(FMDatabase *)db
{
    [MBFUtils printDBError:db];
}

- (void)onCreate:(FMDatabase *)databse
{
    // super class do nothing, subclass should override this.
}

- (void)onUpgrade:(FMDatabase *)database
      fromVersion:(NSUInteger)from
        toVersion:(NSUInteger)to
{
    [self updateTablePolicy:database];
}

- (void)onDegrade:(FMDatabase *)database
      fromVersion:(NSUInteger)from
        toVersion:(NSUInteger)to
{
    [self updateTablePolicy:database];
}

#pragma mark - private method
-(void)updateTablePolicy:(FMDatabase *)database
{
    NSString *dropOldTableSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",self.tableName];
    
    BOOL droped = [database executeUpdate:dropOldTableSQL];
    if (droped) {
        [self onCreate:database];
    }else{
        [self printDBError:database];
    }
}

@end
