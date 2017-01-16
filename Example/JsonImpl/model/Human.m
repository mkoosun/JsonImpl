//
//  Human.m
//  JsonImpl
//
//  Created by mkoo on 2017/1/1.
//  Copyright © 2017年 mkoo.sun. All rights reserved.
//

#import "Human.h"
#import "NSObject+JsonImpl.h"

@implementation Human

+ (void)initialize
{
    if (self == [Human class]) {
        [self setArrayProperty:@"friends" withClass:@"Human"];
    }
}


@end
