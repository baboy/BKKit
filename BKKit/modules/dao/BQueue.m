//
//  QDao.m
//  BackgroundTracker
//
//  Created by Zhang Yinghui on 12-5-3.
//  Copyright (c) 2012年 Wakefield School. All rights reserved.
//

#import "BQueue.h"
#import "BKKitDefines.h"
#import "Utils.h"
#import "NSString+x.h"

@implementation BQueueItem

- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setDomain:[dict valueForKey:@"domain"]];
        
        [self setQid:[dict valueForKey:@"qid"]];
        [self setKey:[dict valueForKey:@"key"]];
        [self setID:[[dict valueForKey:@"id"] intValue]];
        [self setData:nullToNil([dict valueForKey:@"data"])];
        [self setData2:nullToNil([dict valueForKey:@"data2"])];
        [self setData3:nullToNil([dict valueForKey:@"data3"])];
        [self setData4:nullToNil([dict valueForKey:@"data4"])];
        [self setData5:nullToNil([dict valueForKey:@"data5"])];
        [self setData6:nullToNil([dict valueForKey:@"data6"])];
        [self setStatus:[nullToNil([dict valueForKey:@"status"]) intValue]];
    }
    return self;
}


@end

@implementation BQueue

+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withDatas:(NSString *)data, ...{
    if ((!data && !key) || !qid) {
        return NO;
    }
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:5];
    if (data) {
        va_list args;
        va_start(args, data);
        id arg;
        
        while ( (arg = va_arg(args, NSString*) ) != nil) {
            [datas addObject:arg];
            if ([datas count]>=5) {
                break;
            }
        }
        va_end(args);
    }
    for (NSInteger i=[datas count]; i<5; i++) {
        [datas addObject:[NSNull null]];
    }
    FMDatabase *db = [self db];
	BOOL ret =[db executeUpdate:@"INSERT INTO queue (qid, key, data, data2, data3, data4, data5, data6) VALUES (?,?,?,?,?,?,?,?)",qid, key?:[NSNull null], data, [datas objectAtIndex:0], [datas objectAtIndex:1], [datas objectAtIndex:2], [datas objectAtIndex:3], [datas objectAtIndex:4]];
    DLOG(@"<%@,%@> state<%d>", qid, key, ret);
    if (!ret) {
        DLOG(@"error:%@",[[self db] lastErrorMessage]);
    }
	[self close:db];
	return ret;
}
+ (BOOL) addForQueue:(NSString *)qid withKey:(NSString *)key withData:(NSString *)data{
    return [self addForQueue:qid withKey:key withDatas:data, nil];
}
+ (BOOL) addForQueue:(NSString *)qid withData:(NSString *)data{
    return [self addForQueue:qid withKey:nil withDatas:data, nil];
}

+ (BQueueItem *) getOneItemByQueue:(NSString *)qid{
    BQueueItem *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE qid=? LIMIT 0,1",qid];
    if ([rs next]) {
        ret = [[BQueueItem alloc] initWithDictionary:[rs resultDictionary]];
    }
    [self close:db];
	return ret;
}
+ (BQueueItem *) getOneItemByQueue:(NSString *)qid key:(NSString *)key{
    BQueueItem *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE qid=? AND key=? LIMIT 0,1",qid,key];
    if ([rs next]) {
        ret = [[BQueueItem alloc] initWithDictionary:[rs resultDictionary]];
    }
    [self close:db];
	return ret;
}
+ (NSArray *) getAllItemsByQueue:(NSString *)qid{
    return [self getAllItemsByQueue:qid itemClass:nil];
}
+ (NSArray *) getAllItemsByQueue:(NSString *)qid itemClass:(Class)clazz{
    NSMutableArray *ret = nil;
    FMDatabase *db = [self db];
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM queue WHERE qid=? ORDER BY id ASC", qid];
    ret = [NSMutableArray array];
    while ([rs next]) {
        BQueueItem *qItem = /*AUTORELEASE*/([[BQueueItem alloc] initWithDictionary:[rs resultDictionary]]);
        id qData = clazz ? /*AUTORELEASE*/([[clazz alloc] initWithDictionary:[[qItem data] json]]) : qItem;
        [ret addObject:qData];
    }
	[self close:db];
	return ret;
}
+ (BOOL) setStatus:(int) status forId:(int)ID{
    return [self updateField:DBQFieldStatus value:[NSString stringWithFormat:@"%d", status] forId:ID];
}
+ (BOOL) removeById:(int) ID{
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    ret = [db executeUpdate:@"DELETE FROM queue WHERE id=?",[NSNumber numberWithInt:ID]];
	[self close:db];
	return ret;
}

+ (BOOL) removeByQueue:(NSString *)qid key:(NSString *)key{
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    ret = [db executeUpdate:@"DELETE FROM queue WHERE qid=? AND key=?", qid, key];
	[self close:db];
	return ret;
}
+ (BOOL) removeByQueue:(NSString *)qid{
    
    return [self removeByField:DBQFieldQID value:qid];
}
+ (BOOL) removeByField:(NSString *)field value:(NSString *)val{
    
    BOOL ret = NO;
    FMDatabase *db = [self db];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM queue WHERE %@=?",field];
    ret = [db executeUpdate:sql,val];
	[self close:db];
	return ret;
}
+ (BOOL) updateField:(NSString *)field value:(NSString *)val forField:(NSString*)field2 value:(id)val2{
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    NSString *sql = @"UPDATE queue set %@=? WHERE %@=? ";
    sql = [NSString stringWithFormat:sql,field,field2];
    ret = [db executeUpdate:sql,val,val2];
	[self close:db];
	return ret;
}
+ (BOOL) updateField:(NSString *)field value:(NSString *)val forId:(int)ID{
    return [self updateField:field value:val forField:DBQFieldID value:[NSNumber numberWithInt:ID]];
}

+ (BOOL) updateField:(NSString *)field value:(NSString *)val forQueue:(NSString *)qid key:(NSString *)key{
    
    BOOL ret = NO;
    FMDatabase *db = [self db] ;
    NSString *sql = @"UPDATE queue set %@=? WHERE qid=? AND key=?";
    sql = [NSString stringWithFormat:sql,field];
    ret = [db executeUpdate:sql,val,qid,key];
	[self close:db];
	return ret;
}

+ (BOOL) updateData:(NSString *)val forQueue:(NSString *)qid key:(NSString *)key{
    
    return [self updateField:DBQFieldData value:val forQueue:qid key:key];
}
@end

