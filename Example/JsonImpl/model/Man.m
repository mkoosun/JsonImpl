//
//  Man.m
//  JsonImpl
//
//  Created by mkoo on 2017/1/1.
//  Copyright © 2017年 mkoo.sun. All rights reserved.
//

#import "Man.h"
#import "NSObject+JsonImpl.h"

@implementation Man

+ (void)initialize
{
    if (self == [Man class]) {
        [self setArrayProperty:@"childrens" withClass:@"Human"];
        [self setIgnoreProperty:@"intProperty"];
    }
}

@end
