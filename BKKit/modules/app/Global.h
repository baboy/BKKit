//
//  G.h
//  iLook
//
//  Created by Zhang Yinghui on 5/27/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G : NSObject
+ (void)setup:(NSString *)plist;
+ (id) valueForKey:(id)key;
+ (void) setValue:(id)val forKey:(id)key;
+ (id)remove:(id)key;
+ (NSDictionary *) dict;
@end


