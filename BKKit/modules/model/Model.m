//
//  Model.m
//  XChannel
//
//  Created by baboy on 8/5/14.
//  Copyright (c) 2014 baboy. All rights reserved.
//

#import "Model.h"
#import "Global.h"
#import "Utils.h"
#import <objc/message.h>
#import "BKKitCategory.h"

#define  DebugLog(...) //NSLog(@"[DEBUG][%s] - [line:%d] %@",__func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);

@implementation Model
- (id) initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self build:dict];
    }
    return self;
}
- (NSDictionary *)fieldMap{
    return nil;
}
- (NSString *)getterName:(NSString *)field{
    BOOL needTrans = [field rangeOfString:@"_"].length > 0;
    if(needTrans){
        field = [[field stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
        field = [field stringByReplacingCharactersInRange:(NSRange){0,1} withString:[[field substringToIndex:1] lowercaseString]];
    }
    field = [[field split:@" "] join:@""];
    NSArray *fields = [self allFields];
    for (NSString *i in fields) {
        if ([[field lowercaseString] isEqualToString:[i lowercaseString]]) {
            return i;
        }
    }
    NSDictionary *fMap = [self fieldMap];
    if (fMap && [fMap valueForKey:field]) {
        return [fMap valueForKey:field];
    }
    return field;
}
- (NSString *)setterName:(NSString *)field{
    field = [self getterName:field];
    field = [field stringByReplacingCharactersInRange:(NSRange){0,1} withString:[[field substringToIndex:1] uppercaseString]];
    NSString *setter = [NSString stringWithFormat:@"set%@:",field];
    return setter;
}
- (void)setValuesWithDictionary:(NSDictionary*)dict forKeys:(NSArray *)keys{
    for (NSString *k in keys) {
        id v = nullToNil( [dict valueForKey:k] );
        NSString *act = [self setterName:k];
        SEL sel = NSSelectorFromString(act);
        if ([self respondsToSelector:sel]) {
            IMP imp = [self methodForSelector:sel];
            void(*func)(id, SEL, id) = (void *)imp;
            func(self, sel, v);
        }
    }
}
- (NSMutableDictionary *)dictForFields:(NSArray *)fields{
    DebugLog(@"%@",fields);
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    for (NSString *k in fields) {
        NSString *field = k;
        if ( [field rangeOfString:@"_"].length>0 ) {
            field = [[[[k stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] split:@" "] join:@""];
            field = [NSString stringWithFormat:@"%@%@",[[field substringToIndex:1] lowercaseString],[field substringFromIndex:1]];
        }
        DebugLog(@"field:%@",field);
        
        SEL action = NSSelectorFromString(field);
        if (![self respondsToSelector:action]) {
            continue;
        }
        id val = [self valueForKey:field];
//        IMP imp = [self methodForSelector:action];
//        id (*_propValue)() = (void *)imp;
//        id val = _propValue(self, action);
        if ([val isKindOfClass:[NSArray class]]) {
            val = [val json];
        }else if ([val isKindOfClass:[NSDictionary class]]){
            val = [val json];
        }else if ([val respondsToSelector:@selector(dict)]) {
            val = [val dict];
        }
        if (val)
            [d setValue:val forKey:field];
    }
    return d;
}

/***********************/
+ (NSDictionary *)attributeDictionary{
    if ([NSStringFromClass([self class]) isEqualToString:@"Model"]) {
        return nil;
    }
    
    NSDictionary *parentDict = [[self superclass] attributeDictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parentDict];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        const char *typeName = property_getAttributes(property);
        NSString *classOriginName = [NSString stringWithUTF8String:typeName];
        NSString *className = [self parseClassName:classOriginName];
        [dict setObject:className forKey:propName];
    }
    if (properties) {
        free(properties);
    }
    return dict;
}
+ (NSString*) parseClassName:(NSString *)classOriginName {
    NSString* name = [[classOriginName componentsSeparatedByString:@","] objectAtIndex:0];
    if([name isEqualToString:@"Ti"]){
        return @"int";
    }
    if([name isEqualToString:@"Td"]){
        return @"double";
    }
    if([name isEqualToString:@"Tf"]){
        return @"float";
    }
    if([name isEqualToString:@"Tc"]){
        return @"boolean";
    }
    if([name isEqualToString:@"Tq"]){
        return @"long";
    }
    if([name isEqualToString:@"T@"]){
        return @"id";
    }
    NSString* className = [[name substringToIndex:[name length]-1] substringFromIndex:3];
    if ([className rangeOfString:@"<"].location != NSNotFound) {
        NSString* subName = [className substringFromIndex:[className rangeOfString:@"<"].location+1];
        return [subName substringToIndex:[subName length]-1];
    }
    return className;
}
- (void)build:(NSDictionary *)data{
    NSDictionary *attributes = [[self class] attributeDictionary];
    for (NSString *key in [data allKeys]){
        id val = nullToNil([data objectForKey:key]);
        NSString *field = [self getterName:key];
        
        NSString *setter = [self setterName:key];
        SEL sel = NSSelectorFromString(setter);
        if ([self respondsToSelector:sel]) {
            if (val) {
                NSString* className = [attributes valueForKey:field];
                
                
                if ([className isEqualToString:@"int"]) {
                    int v = [val intValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, int) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"float"]) {
                    float v = [val floatValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, float) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"double"]) {
                    double v = [val doubleValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, double) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                if ([className isEqualToString:@"long"]) {
                    long long v = [val longLongValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, long long) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                
                if ([className isEqualToString:@"boolean"]) {
                    BOOL v = [val boolValue];
                    // set value
                    IMP imp = [self methodForSelector:sel];
                    void(*func)(id, SEL, BOOL) = (void *)imp;
                    func(self, sel, v);
                    continue;
                }
                id v = val;
                if ([className isEqualToString:@"NSString"]) {
                    if ([val isKindOfClass:[NSArray class]] || [val isKindOfClass:[NSDictionary class]]) {
                        v = [val jsonString];
                    }else{
                        v = [val description];
                    }
                }else if ([val isKindOfClass:[NSArray class]]) {
                    
                    className = [attributes valueForKey:[NSString stringWithFormat:@"%@Item",field]];
                    if (!className) {
                        NSString *icField = [NSString stringWithFormat:@"%@ItemClass",field];
                        SEL ica = NSSelectorFromString(icField);
                        if ([self respondsToSelector:ica]) {
                            className = [self valueForKey:icField];
                            if (!className || [className isEqualToString:@""]) {
                                className = nil;
                            }
                        }
                    }
                    Class clazz = NSClassFromString(className);
                    if (clazz) {
                        
                        v = [NSMutableArray array];
                        for (NSInteger i = 0, n = [val count]; i < n; i++) {
                            if (className) {
                                id item = ([[clazz alloc] initWithDictionary:[val objectAtIndex:i]]);
                                [v addObject:item];
                            }
                        }
                    }
                }else if ([className isEqualToString:@"NSDate"]) {
                    if ([val isKindOfClass:[NSNumber class]]) {
                        v = [NSDate dateWithTimeIntervalSince1970:[val longLongValue]];
                    }else{
                        v = [val dateWithFormat:FULLDATEFORMAT];
                    }
                }else if ([NSClassFromString(className) isSubclassOfClass:[NSDictionary class]]) {
                    if ([val isKindOfClass:[NSString class]]) {
                        v = [v json];
                    }
                    v = /*AUTORELEASE*/([[NSClassFromString(className) alloc] initWithDictionary:v]);
                }else if([NSClassFromString(className) isSubclassOfClass:[Model class]]){
                    v = /*AUTORELEASE*/([[NSClassFromString(className) alloc] initWithDictionary:val]);
                }
                // set value
                IMP imp = [self methodForSelector:sel];
                void(*func)(id, SEL, id) = (void *)imp;
                func(self, sel, v);
            }
        }
    }
}

- (NSArray *)allFields{
    NSDictionary *attributes = [[self class] attributeDictionary];
    NSMutableArray *fields = [NSMutableArray array];
    for (NSString *key in [attributes allKeys]){
        NSString *field = key;
        if([key rangeOfString:@"_"].length > 0){
            field = [[[[key stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] split:@" "] join:@""];
            field = [field stringByReplacingCharactersInRange:(NSRange){0,1} withString:[[field substringToIndex:1] lowercaseString]];
        }
        
        SEL sel = NSSelectorFromString(field);
        if ([self respondsToSelector:sel]) {
            [fields addObject:field];
        }
    }
    return fields.count>0?fields:nil;
}

- (NSDictionary *)dict{
    return [self dictForFields:[self allFields]];
}
@end
