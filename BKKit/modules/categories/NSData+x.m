//
//  NSData+x.m
//  Pods
//
//  Created by baboy on 13-3-1.
//
//

#import "NSData+x.h"
#import "BKKitDefines.h"
@implementation NSData(x)
- (id)json{
    NSError *err = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&err];
    if (err) {
        DLOG(@"[NSString] jsonObject error:%@",err);
    }
    return json;
}
@end
