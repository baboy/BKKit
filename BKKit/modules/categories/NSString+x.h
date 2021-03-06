//
//  XNSString.h
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define URLParseKeyString	@"URLParseKeyString"
#define	URLParseKeyPath		@"URLParseKeyPath"
#define URLParseKeyPage		@"URLParseKeyPage"
#define URLParseKeyParam	@"URLParseKeyParam"
#define URLParseKeyUrl		@"URLParseKeyUrl"
#define PH_REGEXP		@"\\{([^\\{\\}]+)\\}"

@interface NSString(x) 
- (NSString *) md5;
- (NSInteger) lastIndexOf:(NSString *)sep;
- (NSInteger) indexOf:(NSString *)sep;
- (NSArray *) split:(NSString *)sep;
- (NSString *) placeHolder:(NSString *)ph withString:(NSString *) s;
- (NSDate *)dateWithFormat:(NSString *)format;
- (int)compareToVersion:(NSString *)version;
- (BOOL)isURL;
- (NSString *)shortPinyin;
- (BOOL)isEmail;
- (BOOL)testRegex:(NSString *)re;
- (BOOL)isDigital;

/******* file operation*******/
- (NSError *)removeFile;
- (BOOL)copyFileTo:(NSString *)newPath;
- (BOOL)deleteFile;
- (long long)sizeOfFile;
- (NSData *)fileData;
- (BOOL)fileExists;
- (BOOL)renameFileTo:(NSString *)to;

- (id)json;
- (NSString *)base64SHA1HmacWithKey:(NSString *)key;
- (int)textCount;
- (NSString *)pinyin;
- (NSArray *) placeholders;
- (NSString *) replaceholders:(NSDictionary *)param;
- (NSDictionary *) parseURLStringWithParam:(NSDictionary *)param;
- (NSString *)	URLStringWithParam:(NSDictionary *)param;
@end
