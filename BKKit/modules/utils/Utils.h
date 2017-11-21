//
//  Utils.h
//  iLook
//
//  Created by Zhang Yinghui on 5/25/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define URLParseKeyString	@"URLParseKeyString"
#define	URLParseKeyPath		@"URLParseKeyPath"
#define URLParseKeyPage		@"URLParseKeyPage"
#define URLParseKeyParam	@"URLParseKeyParam"
#define URLParseKeyUrl		@"URLParseKeyUrl"
#define BUNDLE_FILE(args)   getBundleFile


extern NSString * getImageCacheDir(void);
extern NSString * getFilePath(NSString *dir,NSString *fn, NSString *ext);
extern NSString * getBundleFile(NSString *fn);
extern NSString * getBundleFileFromBundle(NSString *fn,
                                          NSString *fileType,
                                          NSString *bundleName,
                                          NSString *inDir);

extern NSString * getCacheDir(NSString *dir);
extern NSString * getTempFilePath(NSString *fn);
extern id nullToNil(id obj);
extern id nilToNull(id obj);
extern BOOL strIsNil(NSString *s);
extern BOOL isURL(NSString *s);
extern NSString * getChineseCalendar(NSDate * date);

@interface Utils : NSObject 
+ (BOOL)			createNewFileAtPath:(NSString *)fn;
+ (BOOL)			createFileIfNotExist:(NSString *)fn;
+ (long long)	sizeOfFile:(NSString *)fn;
+ (NSString *)	format:(NSString *)f time:(long long )t;
+ (NSString *) formatSize:(long long)size;
+ (NSString *)	formatToTime:(NSInteger)t;
+ (NSString *)	getChineseWeek:(int)n;
+ (NSInteger)	getStartTimestampOfDay:(long long)time;
+ (NSInteger)	getEndTimestampOfDay:(long long)time;
+ (NSInteger)	getEndTimestampOfHour:(long long)time;
@end
