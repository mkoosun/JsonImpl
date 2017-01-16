//
//  JsonImpl.h
//  Pods
//
//  Created by mkoo on 2017/1/1.
//
//

#import <Foundation/Foundation.h>

@protocol Ignore
@end

@interface NSObject (JsonImpl)

+ (void) setArrayProperty:(NSString*) property withClass:(NSString*) className;

+ (void) setIgnoreProperty:(NSString*) property;

- (NSDictionary *) toJsonDictionary;

- (void) parse: (NSObject*) dict;

- (NSString*) toJsonString;


@end
