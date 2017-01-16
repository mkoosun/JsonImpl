//
//  Human.h
//  JsonImpl
//
//  Created by mkoo on 2017/1/1.
//  Copyright © 2017年 mkoo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonImpl.h"

@interface Human : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) NSString<Ignore> * name;

@property (nonatomic, strong) NSString* birthDay;

@property (nonatomic, strong) NSArray* likes;

@property (nonatomic, strong) NSArray* friends;


@end
