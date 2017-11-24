//
//  Dao.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/4/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "Dao.h"
#import "Utils.h"
#import "BKKitDefines.h"

//#define dbFile			@"db.sqlite"
//#define sqlFile			@"sql.plist"

static NSMutableDictionary *_dbPool_ = nil;


@implementation Dao
+ (NSMutableDictionary *)dbPool{
    @synchronized(_dbPool_){
        if(_dbPool_ == nil){
            _dbPool_ = [[NSMutableDictionary alloc] initWithCapacity:2];
        }
        return _dbPool_;
    }
    
}
+ (void)initialize{
    if ([NSStringFromClass(self) isEqualToString:NSStringFromClass([Dao class])]) {
        [self setup:@"db"];
    }
}
+ (BOOL)setup:(NSString *)name{
    NSString *f = getBundleFile([NSString stringWithFormat:@"%@.plist",name]);
    BOOL ret = NO;
    NSArray *arr = [NSArray arrayWithContentsOfFile:f];
    if (arr && [arr count]) {
        NSInteger n = [arr count];
        NSInteger i = 0;
        for ( NSString *sql in arr ) {
            i += [self execSQL:sql withArgs:nil]?1:0;
        }
        ret = i == n;
    }
    //DLOG(@"[Dao] setup create: %d", ret);
    return ret;
}
+ (BOOL)close:(FMDatabase*)db{
    return YES;
}
+ (BOOL)close{
    return YES;
}
+ (FMDatabase*)db:(NSString *)ns{
    FMDatabase *dbase = [[self dbPool] valueForKey:ns];
    if (!dbase) {
        NSString *dbName = getFilePath(nil,[NSString stringWithFormat:@"%@.db", ns], nil);
        DLOG(@"init db:%@", dbName);
        dbase = [FMDatabase databaseWithPath:dbName];
        [[self dbPool] setValue:dbase forKey:ns];
    }
    [dbase open];
    return dbase;
}
+ (FMDatabase*)db{
    return[self db:@"db"];
}

+ (BOOL) execSQL:(NSString *)sql withArgs:(NSArray *)args{
    BOOL ret = NO;
    ret = [[self db] executeUpdate:sql withArgumentsInArray:args];
    if (!ret) {
        NSString *errMsg = [[Dao db] lastErrorMessage];
        DLOG(@"errMsg:%@",errMsg);
    }
    return ret;
}
@end

