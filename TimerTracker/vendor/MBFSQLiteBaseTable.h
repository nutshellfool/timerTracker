//
//  MBFSQLiteBaseTable.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface MBFSQLiteBaseTable : NSObject

// The property reference to handle the table level db operation.
@property (nonatomic, strong)FMDatabaseQueue *databaseQueue;

@property (nonatomic, strong)NSString *tableName;

- (id)initWithTableName:(NSString *)tableName;

- (void)printDBError:(FMDatabase *)db;

- (void)onCreate:(FMDatabase *)databse;

- (void)onUpgrade:(FMDatabase *)database
      fromVersion:(NSUInteger)from
        toVersion:(NSUInteger)to;

- (void)onDegrade:(FMDatabase *)database
      fromVersion:(NSUInteger)from
        toVersion:(NSUInteger)to;

@end
