//
//  Model.h
//  XChannel
//
//  Created by baboy on 8/5/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
//@property (nonatomic, strong) id object;
- (id) initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)fieldMap;
- (void)build:(NSDictionary *)data;
- (void)setValuesWithDictionary:(NSDictionary*)dict forKeys:(NSArray *)keys;
- (NSMutableDictionary *)dictForFields:(NSArray *)fields;
- (NSDictionary *)dict;

- (NSArray *)allFields;
@end
