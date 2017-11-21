//
//  Dao.h
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/4/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface Dao : NSObject
+ (FMDatabase*)db;
+ (FMDatabase*)db:(NSString *)ns;
+ (BOOL) setup:(NSString *)name;
+ (BOOL) close:(FMDatabase*)db;
+ (BOOL) close;

+ (BOOL) execSQL:(NSString *)sql withArgs:(NSArray *)args;
@end

@interface NamespaceDao : Dao
@end
