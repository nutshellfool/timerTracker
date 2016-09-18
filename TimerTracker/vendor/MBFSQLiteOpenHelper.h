//
//  MBFSQLiteOpenHelper.h
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface MBFSQLiteOpenHelper : NSObject

/**
 * The database name.
 */
@property (nonatomic, strong)NSString *datebaseName;

/**
 * The database version.
 */
@property (nonatomic) NSUInteger currentDBVersion;
//int m_newVersion;

// ----------------------------------------------
//  the only init method of DB init method.
//
// ----------------------------------------------

- (id) initWithName:(NSString *) strDBName withVersion:(int) nDBVersion;

// ----------------------------------------------
// DB operation
//
//-----------------------------------------------

/**
 * Get the data base.
 */
- (void)getDatabase;

/**
 * Close db.
 */
- (void)close;

// -----------------------------------------------
// direct wraper for FMBD interface
//
// -----------------------------------------------

/**
 * Operate db in nomal synchronized way.
 *
 * @param block  the db operation block to be operated.
 */
- (void)inDatabase:(void (^)(FMDatabase *db))block;

/**
 * Operate db in thransaction.
 *
 * @param block  the db operation block to be operated.
 */
- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/**
 * Operate db in defered thransaction.
 *
 * @param block  the db operation block to be operated.
 */
- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

// ------------------------------------------------
// the DB basic operation.
//
// ------------------------------------------------

- (FMResultSet *)queryByTableName:(NSString *)tableName
             withProjectionString:(NSString *)projectionString
                  withWhereClause:(NSString *)whereClause;

- (BOOL)deleteByTableName:(NSString *)tableName
          withWhereClause:(NSString *)whereClause;

// ------------------------------------------------
// the DB important callback.
//
// ------------------------------------------------

/**
 * Call this method when it starts to create the db.
 */
// sub class should call super class' onCreate when override this.
- (void)onCreate:(FMDatabase*) db;

/**
 * Call this method when it starts to open the db.
 */
- (void)onOpen:(FMDatabase*) db;

/**
 * Call this method when it starts to upgrade the db.
 */
- (void)onUpgrade:(FMDatabase*)db :(NSUInteger)fromVersion :(NSUInteger)toVersion;

/**
 * Call this method when it starts to downgrade the db.
 */
- (void)onDowngrade:(FMDatabase*)db :(NSUInteger)fromVersion :(NSUInteger)toVersion;

- (void)onCreateIndex:(FMDatabase *)db;

- (NSArray *)allTables;

- (void)printDBError:(FMDatabase *)db;

@end
