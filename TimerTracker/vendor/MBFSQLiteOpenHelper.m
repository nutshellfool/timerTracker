//
//  MBFSQLiteOpenHelper.m
//  MagicBabyGrowthLine
//
//  Created by Richard Li on 16/8/6.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

#import "MBFSQLiteOpenHelper.h"
#import "FMDatabaseQueue.h"
#import "MBFSQLiteBaseTable.h"
#import "MBFFileUtils.h"
#import "MBFUtils.h"

@interface MBFSQLiteOpenHelper ()

/**
 * The database queue to manager the synchronized db operation.
 */
@property (nonatomic, strong)FMDatabaseQueue *databaseQueue;

@property (nonatomic, strong)NSArray *allTables;

/**
 * Create new db with the given path.
 *
 * @param dbPath the db path.
 */
-(void)createNewDBWithPath:(NSString*)dbPath;

/**
 * Upgrage or downgrage db with the given path.
 *
 * @param dbPath the db path.
 */
-(void)upOrDowngrageDBWithPath:(NSString*)dbPath;

- (NSArray *)loadAllTables;

- (void)AssembleDatabaseQueue;
@end
@implementation MBFSQLiteOpenHelper


//@synthesize databaseQueue;

#pragma mark - init
- (id) initWithName:(NSString *) strDBName withVersion:(int) nDBVersion
{
    self = [super init];
    if (self)
    {
        if (strDBName && ([strDBName length] > 0))
        {
            self.datebaseName = strDBName;
            self.currentDBVersion = nDBVersion;
        }
    }
    
    return self;
}

- (id)init
{
    NSAssert(NO, @"can not init by this, use the initWithName: : instead");
    
    return [super init];
}

#pragma mark - DB operation

- (void) getDatabase
{
    NSString *docRootPath = [MBFFileUtils docRootPath];
    NSString* dbpath = [docRootPath stringByAppendingPathComponent:self.datebaseName];
    NSLog(@"database name %@", self.datebaseName);
    
    [self loadAllTables];
    
    if([MBFFileUtils isFileExistForPath:dbpath isDirectory:NO])
    {
        NSLog(@"DB file at path %@ exist", dbpath);
        [self upOrDowngrageDBWithPath:dbpath];
    }
    else
    {
        NSLog(@"DB file at path %@ do NOT exist", dbpath);
        [self createNewDBWithPath:dbpath];
    }
    
    [self AssembleDatabaseQueue];
}

- (void)close
{
    [self.databaseQueue close];
}

#pragma mark - direct wraper for FMBD interface

- (void)inDatabase:(void (^)(FMDatabase *db))block
{
    
    [self.databaseQueue inDatabase:block];
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [self.databaseQueue inTransaction:block];
}

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [self.databaseQueue inDeferredTransaction:block];
}


#pragma mark -  important DB callback.

- (void)onCreate:(FMDatabase*) db
{
    NSArray *tables = self.allTables;
    
    for (MBFSQLiteBaseTable *tableItem in tables) {
        [tableItem onCreate:db];
    }
    
    [self onCreateIndex:db];
}

- (void)onOpen:(FMDatabase*) db
{
    // Turn on foreign key switch.
    [db executeUpdate:@"PRAGMA foreign_keys=ON;"];
}

- (void)onUpgrade:(FMDatabase*)db :(NSUInteger)fromVersion :(NSUInteger)toVersion
{
    if (self.allTables) {
        for (MBFSQLiteBaseTable *tableItem in self.allTables) {
            [tableItem onUpgrade:db fromVersion:fromVersion toVersion:toVersion];
            
        }
    }
    
    [self onCreateIndex:db];
    
}

- (void)onDowngrade:(FMDatabase*)db :(NSUInteger)fromVersion :(NSUInteger)toVersion
{
    if (self.allTables) {
        for (MBFSQLiteBaseTable *tableItem in self.allTables) {
            [tableItem onDegrade:db fromVersion:fromVersion toVersion:toVersion];
        }
    }
    
    [self onCreateIndex:db];
}

- (void)onCreateIndex:(FMDatabase *)db
{
    // super class do nothing
}

- (NSArray *)allTables;
{
    return nil;
}

#pragma mark - Basic DB operation

- (FMResultSet *)queryByTableName:(NSString *)tableName
             withProjectionString:(NSString *)projectionString
                  withWhereClause:(NSString *)whereClause
{
    __block FMResultSet *result;
    
    if (!projectionString) {
        projectionString = @"*";
    }
    
    [self inDatabase:^(FMDatabase *db){
        result = [db executeQueryWithFormat:@"SELECT %@ FROM %@ WHERE %@", projectionString, tableName, whereClause];
    }];
    
    return result;
}

- (BOOL)deleteByTableName:(NSString *)tableName
          withWhereClause:(NSString *)whereClause
{
    __block BOOL succeed;
    [self inDatabase:^(FMDatabase *db){
        succeed = [db executeUpdateWithFormat:@"DELETE FROM %@ WHERE %@", tableName, whereClause];
    }];
    
    return succeed;
}

#pragma mark - Private Method

-(void)createNewDBWithPath:(NSString*)dbPath
{
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if(self.databaseQueue != nil)
    {
        __block FMDatabase * tempDb;
        NSLog(@" Create DataBase success");
        // Set Version
        [self.databaseQueue inDatabase:^(FMDatabase *db)
         {
             tempDb = db;
             NSString* setversionString = [[NSString alloc] initWithFormat:@"PRAGMA user_version = %ld", (unsigned long)self.currentDBVersion];
             BOOL bResult = [db executeUpdate:setversionString];
             if(bResult)
             {
                 NSLog(@"Set DataBase Version success version=%ld", (unsigned long)self.currentDBVersion);
             }
             else
             {
                 NSLog(@"Set DataBase Version fail");
             }
         }];
        
        [self onOpen:tempDb];
        [self onCreate:tempDb];
    }
}

-(void)upOrDowngrageDBWithPath:(NSString*)dbPath
{
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if(self.databaseQueue)
    {
        __block FMDatabase * tempDb;
        NSLog(@"Open DataBase success");
        __block long oldVersion = -1;
        __block BOOL bResult = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db)
         {
             tempDb = db;
             NSString* readVersionString = @"PRAGMA user_version";
             FMResultSet *cursor = [db executeQuery:readVersionString];
             
             if(cursor != nil)
             {
                 if([cursor next])
                 {
                     oldVersion = [cursor longForColumn:@"user_version"];
                 }
                 [cursor close];
             }
             
             NSLog(@"Get DataBase Version version=%li, m_newVersion=%ld", oldVersion, (unsigned long)self.currentDBVersion);
             
             if(oldVersion != -1 && oldVersion != self.currentDBVersion)
             {
                 NSString* setversionString =
                 [[NSString alloc] initWithFormat:@"PRAGMA user_version = %ld", (unsigned long)self.currentDBVersion];
                 
                 bResult = [db executeUpdate:setversionString];
             }
             else
             {
                 bResult = YES;
             }
         }];
        
        if(bResult)
        {
            NSLog(@"Set DataBase Version success version=%ld", (unsigned long)self.currentDBVersion);
            [self onOpen:tempDb];
            
            if (oldVersion < self.currentDBVersion) {
                [self onUpgrade:tempDb
                               :oldVersion
                               :self.currentDBVersion];
            }
            else if (oldVersion > self.currentDBVersion)
            {
                [self onDowngrade:tempDb
                                 :oldVersion
                                 :self.currentDBVersion];
            }
        }
        else
        {
            NSLog(@"Set DataBase Version fail");
        }
    }
}

- (NSArray *)loadAllTables;
{
    NSArray *tables = [self allTables];
    NSAssert((tables && [tables count] > 0), @" Table count = 0 is not allowed !");
    
    self.allTables = tables;
    
    return tables;
}

- (void)AssembleDatabaseQueue
{
    NSAssert(self.databaseQueue != nil, @" database queue can not be nil");
    
    for (MBFSQLiteBaseTable *tableItem in self.allTables) {
        tableItem.databaseQueue = self.databaseQueue;
    }
}

- (void)printDBError:(FMDatabase *)db
{
    [MBFUtils printDBError:db];
}

@end
