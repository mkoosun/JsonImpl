//
//  JsonImpl.m
//  Pods
//
//  Created by mkoo on 2017/1/1.
//
//

#import "NSObject+JsonImpl.h"
#import <objc/runtime.h>

static int kArrayProperties;
static int kIgnoreProperties;

@implementation NSObject (JsonImpl)

#pragma mark - public api

+ (void) setArrayProperty:(NSString*) property withClass:(NSString*) className {
    
    //const char *name = object_getClassName(self);
    //NSString *myClassName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    Class cls = self;
    
    NSMutableDictionary *dictionary = objc_getAssociatedObject(cls, &kArrayProperties);
    if(dictionary == nil) {
        dictionary = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &kArrayProperties, dictionary, OBJC_ASSOCIATION_RETAIN);
    }
    [dictionary setObject:className forKey:property];
}

+ (void) setIgnoreProperty:(NSString*) property {
    
    //const char *name = object_getClassName(self);
    //NSString *myClassName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    Class cls = self;
    
    NSMutableArray *ignoreArray = objc_getAssociatedObject(cls, &kIgnoreProperties);
    if(ignoreArray == nil) {
        ignoreArray = [NSMutableArray new];
        objc_setAssociatedObject(cls, &kIgnoreProperties, ignoreArray, OBJC_ASSOCIATION_RETAIN);
    }
    
    if(![ignoreArray containsObject:property]) {
        [ignoreArray addObject:property];
    }
}

- (NSDictionary *) toJsonDictionary {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    
    Class cls = self.class;
    [self _toJsonDict:dict inClass:cls];
    
    cls = class_getSuperclass(cls);
    while (cls != [NSObject class]) {
        
        [self _toJsonDict:dict inClass:cls];
        cls = class_getSuperclass(cls);
    }
    
    return dict;
}

- (void) parse: (NSObject *) object {
    
    if(object == nil) {
        return;
    }
    
    NSDictionary* dict = nil;
    
    if([object isKindOfClass:[NSString class]]) {
        
        NSData* jsonData = [(NSString*)object dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
    } else if([object isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        dict = [NSJSONSerialization JSONObjectWithData:(NSData*)object options:NSJSONReadingAllowFragments error:&error];
        
        if(error) {
            return;
        }
        
    } else if([object isKindOfClass:[NSDictionary class]]) {
        
        dict = (NSDictionary*)object;
    }
    
    if(dict == nil) {
        return;
    }
    
    Class cls = self.class;
    [self _parseJsonDict:dict inClass:cls];
    
    cls = class_getSuperclass(cls);
    while (cls != [NSObject class]) {
        
        [self _parseJsonDict:dict inClass:cls];
        cls = class_getSuperclass(cls);
    }
}

- (NSString*) toJsonString {
    
    NSDictionary* dict = [self toJsonDictionary];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

# pragma mark - private methods

- (void) _toJsonDict:(NSMutableDictionary*)dict inClass:(Class)cls {
    
    if(cls == [NSObject class]) {
        return;
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i<outCount; i++) {
        
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSString *jsonPropertyName = propertyName;
        if([propertyName isEqualToString:@"id_"]) {
            jsonPropertyName = @"id";
        }
        
        if([NSObject _isIgnoreProperty:propertyName ofClass:cls]) {
            continue;
        }
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if([propertyValue isKindOfClass:[NSNumber class]]) {
            
            if( isnan([propertyValue floatValue]) || [propertyValue longLongValue] == [[NSNumber numberWithFloat:NAN]longLongValue]) {
                continue;
            }
            
            [dict setObject:propertyValue forKey:jsonPropertyName];
            continue;
        }
        
        if([propertyValue isKindOfClass:[NSString class]] || [propertyValue isKindOfClass:[NSDictionary class]]) {
            [dict setObject:propertyValue forKey:jsonPropertyName];
            continue;
        }
        
        if(propertyValue && [propertyValue isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *subArray = nil;
            
            for(NSObject *arrayItem in propertyValue) {
                if( [arrayItem isKindOfClass:[NSNumber class]] || [arrayItem isKindOfClass:[NSString class]] || [arrayItem isKindOfClass:[NSDictionary class]] ) {
                    [dict setObject:propertyValue forKey:jsonPropertyName];
                    break;
                } else {
                    if(subArray == nil) {
                        subArray = [NSMutableArray new];
                    }
                    [subArray addObject: [arrayItem toJsonDictionary]];
                }
            }
            
            if(subArray) {
                [dict setObject:subArray forKey:jsonPropertyName];
                continue;
            }
            
            continue;
        }
        
        if(propertyValue!=nil) {
            NSDictionary *value = [propertyValue toJsonDictionary];
            if(value.count>0) {
                [dict setObject:[propertyValue toJsonDictionary] forKey:jsonPropertyName];
            }
        }
    }
    free(properties);
}

- (void) _parseJsonDict:(NSDictionary *)dict inClass:(Class)cls {
    
    if(cls == [NSObject class]) {
        return;
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    
    for (i = 0; i<outCount; i++) {
        
        objc_property_t property = properties[i];
        const char * name_char =property_getName(property);
        const char * attributes_char = property_getAttributes(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:name_char];
        
        NSString *jsonPropertyName = propertyName;
        if([propertyName isEqualToString:@"id_"]) {
            jsonPropertyName = @"id";
        }
        
        NSString *propertyType = [NSString stringWithUTF8String:attributes_char];
        
        id propertyValue = [dict objectForKey:jsonPropertyName];
        
        if(propertyValue != nil && propertyValue != [NSNull null]) {
            
            if([propertyValue isKindOfClass:[NSNumber class]]) {
                
                [self setValue:propertyValue forKey:propertyName];
                
            } else if([propertyValue isKindOfClass:[NSArray class]] ) {
                
                NSString *className = [NSObject _getArrayProperty:propertyName ofClass:(Class)cls];
                if(className) {
                    Class cls = NSClassFromString(className);
                    NSMutableArray *subArray = [NSMutableArray new];
                    for(NSObject * item in propertyValue) {
                        if([item isKindOfClass:[NSDictionary class]]) {
                            NSObject *obj = [cls new];
                            [obj parse:item];
                            [subArray addObject:obj];
                        } else {
                            [subArray addObject:item];
                        }
                    }
                    [self setValue:subArray forKey:propertyName];
                    
                } else {
                    [self setValue:propertyValue forKey:propertyName];
                }
                
            } else if([propertyValue isKindOfClass:[NSDictionary class]]) {
                
                if([propertyType hasPrefix:@"T@"]) {
                    
                    NSArray *array = [propertyType componentsSeparatedByString:@"\""];
                    
                    if(array.count>2) {
                        NSString *className = array[1];
                        
                        if([className isEqualToString:@"NSDictionary"] || [className isEqualToString:@"NSMutableDictionary"]) {
                            [self setValue:propertyValue forKey:propertyName];
                            continue;
                        } else {
                            Class cls = NSClassFromString(className);
                            NSObject *obj = [cls new];
                            [obj parse:propertyValue];
                            [self setValue:obj forKey:propertyName];
                        }
                    }
                } else {
                    [self setValue:propertyValue forKey:propertyName];
                }
                
            } else {
                
                [self setValue:propertyValue forKey:propertyName];
            }
            
        } else {
            
            //[self setValue:nil forKey:propertyValue];
        }
    }
    free(properties);
}

+ (BOOL) _isIgnoreProperty:(NSString*)propertyName ofClass:(Class)cls {
    
    if([propertyName hasSuffix:@"_ignore"]) {
        return YES;
    }
    
    //const char *name = object_getClassName(cls);
    //NSString *myClassName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    NSMutableArray *ignoreArray = objc_getAssociatedObject(cls, &kIgnoreProperties);
    if(ignoreArray && [ignoreArray containsObject:propertyName]) {
        return YES;
    }
    
    NSInteger length = [propertyName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char propertyNameChar[length+1];
    [propertyName getCString:propertyNameChar maxLength:length+1 encoding:NSUTF8StringEncoding];
    objc_property_t property = class_getProperty(cls, propertyNameChar);
    
    if(property) {
        
        const char * attributes_char = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:attributes_char];
        
        if([propertyType containsString:@"<Ignore>"]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *) _getArrayProperty:(NSString*) property ofClass:(Class)cls {
    
    //const char *name = object_getClassName(cls);
    //NSString *myClassName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary = objc_getAssociatedObject(cls, &kArrayProperties);
    if(dictionary) {
        NSString *value = [dictionary objectForKey:property];
        return value;
    }
    
    return nil;
}



@end
