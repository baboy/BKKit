//
//  NSDate+x.m
//  iLookForiPhone
//
//  Created by Yinghui Zhang on 6/20/12.
//  Copyright (c) 2012 LavaTech. All rights reserved.
//

#import "NSDate+x.h"

@implementation NSDate(x)
- (NSString *)weekName{
    NSDateFormatter *df = /*AUTORELEASE*/([[NSDateFormatter alloc] init]);
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterLongStyle];
    [df setTimeStyle:NSDateFormatterLongStyle];
    [df setDateFormat:@"ccc"];
    return [df stringFromDate:self];
}
- (NSString *)format:(NSString *)f{
	NSDateFormatter *df = /*AUTORELEASE*/([[NSDateFormatter alloc] init]);
	NSLocale *loc = [NSLocale currentLocale];
	[df setLocale:loc];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterLongStyle];
	[df setDateFormat:f];
	
	NSString *s = [df stringFromDate:self];
	return s;
}
- (NSString *)formatToHumanLang{
    int t = (int)[[NSDate date] timeIntervalSinceDate:self];
    t = MAX(t, 0);
    if (t < 10) {
        return NSLocalizedString(@"刚刚", nil);
    }
    if (t < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d秒前", nil), t];
    }
    
    if (t < 3600) {
        t = t/60;
        return [NSString stringWithFormat:NSLocalizedString(@"%d分钟前", nil), t];
    }
    if (t < 3600*24) {
        t = t/3600;
        return [NSString stringWithFormat:NSLocalizedString(@"%d小时前", nil), t];
    }
    if (t < (3600*24 * 7)) {
        t = t/(3600*24);
        return [NSString stringWithFormat:NSLocalizedString(@"%d天前", nil), t];
    }
    if ([[self format:@"yyyy"] isEqualToString:[[NSDate date] format:@"yyyy"]]) {
        return [self format:NSLocalizedString(@"MM-dd HH:mm", nil)];
    }
    return [self format:NSLocalizedString(@"yyyy-MM-dd HH:mm", nil)];
}
- (NSString *)GMTFormat{
    NSDateFormatter *gmtFormatter = /*AUTORELEASE*/([[NSDateFormatter alloc] init]);
    [gmtFormatter setLocale:/*AUTORELEASE*/([[NSLocale alloc] initWithLocaleIdentifier:@"en_US"])];
    [gmtFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [gmtFormatter setTimeZone:tz];
    return [gmtFormatter stringFromDate:self];
}
- (NSString *) formatMessageDate{
    NSDate *now =[NSDate date];
    long long oneDay = 24*3600*1000l;
    long long oneWeek = oneDay*6;
    long long oneMonth = oneDay*30;
    long long halfYear = oneMonth*6;
    
    NSString *f = @"HH:mm";
    long long diff = [now timeIntervalSinceDate:self];
    if( diff > halfYear){
        f = @"yyyy-MM-dd HH:mm";
    }else if(diff > oneWeek){
        f = @"MM-dd HH:mm";
    }else if(diff > oneDay){
        f = @"EEE HH:mm";
    }
    
    return [self format:f];
}
- (NSString *) formatMessageDateShort{
    NSDate *now =[NSDate date];
    long long oneDay = 24*3600*1000l;
    long long oneWeek = oneDay*6;
    long long oneMonth = oneDay*30;
    long long halfYear = oneMonth*6;
    
    NSString *f = @"HH:mm";
    long long diff = [now timeIntervalSinceDate:self];
    if( diff > halfYear){
        f = @"yyyy-MM-dd";
    }else if(diff > oneWeek){
        f = @"MM-dd";
    }else if(diff > oneDay){
        f = @"EEE";
    }
    
    return [self format:f];
}
@end
