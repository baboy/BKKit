//
//  Utils.m
//  iLook
//
//  Created by Zhang Yinghui on 5/25/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "Utils.h"
#import "RegexKitLite.h"
#import "BKKitDefines.h"

#define WEB_CACHE_DIR		@"web_cache"
#define WEB_TMP_DIR		@"web_tmp"
#define DOMAIN_DIRS		NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
#define DAYSEC			24*60*60
#define PH_REGEXP		@"\\{([^\\{\\}]+)\\}"

NSString * getImageCacheDir(){
    NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:FILE_CACHE_DIR];
	if(![fileManager fileExistsAtPath:dir]){
		if(![fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil]){
			return nil;
		}
	}
    return dir;
}
NSString * getBundleFile(NSString *fn){
	NSString *fp = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fn];
	return [[NSFileManager defaultManager] fileExistsAtPath:fp]?fp:nil;
}
NSString * getBundleFileFromBundle(NSString *fn, NSString *fileType,NSString *bundleName, NSString *inDir){
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
	NSString *fp = [bundle pathForResource:fn ofType:fileType inDirectory:inDir];
	return fp;//[[NSFileManager defaultManager] fileExistsAtPath:fp]?fp:nil;
}
NSString * getCacheDir(NSString *dir){
    NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
    NSString *d = dir?[documentsDirectory stringByAppendingPathComponent:dir]:documentsDirectory;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:d]){
        if(![fileManager createDirectoryAtPath:d withIntermediateDirectories:NO attributes:nil error:nil]){
            return nil;
        }
    }
    return d;
}
NSString * getFilePath(NSString *dir,NSString *fn, NSString *ext){
    NSString *documentsDirectory = [DOMAIN_DIRS objectAtIndex:0];
	NSString *d = dir?[documentsDirectory stringByAppendingPathComponent:dir]:documentsDirectory;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:d]){
		if(![fileManager createDirectoryAtPath:d withIntermediateDirectories:NO attributes:nil error:nil]){
			return nil;
		}
	}
    NSString *fp = d;
    if(fn){
        fp = [d stringByAppendingPathComponent:fn];
        if (ext && ![ext isEqualToString:@""]) {
            fp = [fp stringByAppendingPathExtension:ext];
        }
    }
	return fp;
}
NSString * getTempFilePath(NSString *fn){
    NSString *fp = fn;
    if ([fn rangeOfString:@"/"].length == 0) {
        fp = getFilePath(fn, @"tmp", nil);
    }else{
        fp = [fn stringByAppendingPathExtension:@"tmp"];
    }
    return fp;
}
id nullToNil(id obj){
	return obj == [NSNull null]?nil:obj;
}
id nilToNull(id obj){
	return obj == nil?[NSNull null]:obj;
}
BOOL strIsNil(NSString *s){
	NSString *_s = nullToNil(s);
	return (!_s || [_s isEqual:@""])?YES:NO;
}

BOOL isURL(NSString *s){
    s = nullToNil(s);
	if (s && ([[s lowercaseString] hasPrefix:@"http://"] || [[s lowercaseString] hasPrefix:@"https://"])) {
		return YES;
	}
	return NO;
}
NSString * getChineseCalendar(NSDate * date){      
    if(!date)return nil;
    NSArray *chineseYears = [NSArray arrayWithObjects:  
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",  
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",  
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",  
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",  
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",  
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];  
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:  
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",   
                            @"九月", @"十月", @"冬月", @"腊月", nil];  
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:  
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",   
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",  
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];  
    
    
    NSCalendar *localCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localCal components:unitFlags fromDate:date];  
     
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];  
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];  
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];  
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年 %@%@",y_str,m_str,d_str];  
    
    localCal  = nil;
    
    return chineseCal_str;  
}

@implementation Utils
+ (BOOL) createNewFileAtPath:(NSString *)fn{	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:fn]) {
		if ([fileManager removeItemAtPath:fn error:nil]) {
			return NO;
		};
	}
	return [fileManager createFileAtPath:fn contents:nil attributes:nil];
}
+ (BOOL) createFileIfNotExist:(NSString *)fn{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:fn]) {
		return [fileManager createFileAtPath:fn contents:nil attributes:nil];
	}
	return YES;
}
+ (long long) sizeOfFile:(NSString *)fn{
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSDictionary *attrs = [fileManager attributesOfItemAtPath:fn error: NULL]; 
	return [attrs fileSize]; 
}
+ (NSString *)format:(NSString *)f time:(long long )t{
	if ( [[NSString stringWithFormat:@"%qi",t] length] > 10 ) {
		t /= 1000;
	}
    if (t<99999999) {
        NSTimeInterval tmp = [[NSDate date] timeIntervalSince1970];
        t += [Utils getStartTimestampOfDay:tmp];
    }
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	NSLocale *loc = [NSLocale currentLocale];
	[df setLocale:loc];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterLongStyle];
	[df setDateFormat:f];
	
	NSString *s = [df stringFromDate:date];
    df = nil;
	return s;
}
+ (NSString *) formatSize:(long long)size{
	
	NSMutableString *s = [NSMutableString stringWithCapacity:5];
	long long g = 1024*1024*1024,m = 1024*1024,k = 1024,sg;
	float sm;
	if (size>g) {
		sg = size/g;
		size -= sg*g;
		[s appendFormat:@"%lldG",sg];
	}
	if (size>=m*0.1) {
		sm = (float)size/m;
		[s appendFormat:@"%@ %.2fM",s,sm];
	}
	if ([s length]==0 && size>=k) {
		[s appendFormat:@"%.2fK",((float)size/k)];
	}
	if ([s length]==0) {		
		[s appendFormat:@"%lldB",size];
	}
	return [s description] ;
}
+ (NSString *)formatToTime:(NSInteger)t{
	NSInteger d = t/3600/24;
	t -= d*3600*24;
	NSInteger h = t/3600;
	t -= h*3600;
	NSInteger m = t/60;
	t -= m*60;
	NSInteger s = t;
	NSMutableString *str = [NSMutableString stringWithCapacity:5];
	if (d) [str appendFormat:@"%ld天",(long)d];
	if (h) [str appendFormat:@"%ld时",(long)h];
	if (m) [str appendFormat:@"%ld分",(long)m];
	if ([str length]==0 || s) [str appendFormat:@"%ld秒",(long)s];
	return str;
}
+ (NSString *) removeHTMLTag:(NSString *)html{
	NSString *s = [html stringByReplacingOccurrencesOfRegex:@"<[^>]+>" withString:@""];
	s = [s stringByReplacingOccurrencesOfRegex:@"&nbsp;?" withString:@""];
	s = [s stringByReplacingOccurrencesOfRegex:@"[\n\r]+[\t\r \n]*" withString:@"\n"];
	return s;
}

+ (NSString *)	getChineseWeek:(int)n{
	if ( n>7 || n<0 ) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
		[df setLocale:[NSLocale currentLocale]];
		[df setDateStyle:NSDateFormatterLongStyle];
		[df setTimeStyle:NSDateFormatterLongStyle];
		[df setDateFormat:@"ccc"];
		
		return [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:n]];
	}
	
	NSString *s = nil;
	switch (n) {
		case 1:
			s = @"星期一";
			break;
		case 2:
			s = @"星期二";
			break;
		case 3:
			s = @"星期三";
			break;
		case 4:
			s = @"星期四";
			break;
		case 5:
			s = @"星期五";
			break;
		case 6:
			s = @"星期六";
			break;
		case 0:
		case 7:
			s = @"星期日";
			break;
		default:
			s = [NSString stringWithFormat:@"%d",n];
			break;
	}
	return s;
}
+ (NSInteger)getStartTimestampOfDay:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
	NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	[comp setHour:0];
	[comp setMinute:0];
	[comp setSecond:0];
	NSDate *date = [cal dateFromComponents:comp];  
    cal = nil;
	return [date timeIntervalSince1970];
}
+ (NSInteger)getEndTimestampOfDay:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	[comp setHour:23];
	[comp setMinute:59];
	[comp setSecond:59];
	NSDate *date = [cal dateFromComponents:comp];  
    cal = nil;
	return [date timeIntervalSince1970];
}
+ (NSInteger)	getEndTimestampOfHour:(long long)time{
	if ( [[NSString stringWithFormat:@"%qi",time] length] > 10 ) {
		time /= 1000;
	}
	NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:time];
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |  NSCalendarUnitSecond;
	NSDateComponents *comp = [cal components:unitFlags fromDate:refDate];
	NSInteger h = [comp hour];
	[comp setHour:h+1];
	[comp setMinute:0];
	[comp setSecond:0];
	NSDate *date = [cal dateFromComponents:comp];  
    cal = nil;
	return [date timeIntervalSince1970];
}
@end
