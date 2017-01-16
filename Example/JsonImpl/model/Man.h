//
//  Man.h
//  JsonImpl
//
//  Created by mkoo on 2017/1/1.
//  Copyright © 2017年 mkoo.sun. All rights reserved.
//

#import "Human.h"
#import "NSObject+JsonImpl.h"

@interface Man : Human

@property (nonatomic, strong) NSString *job;

@property (nonatomic, strong) NSArray* childrens;

@property (nonatomic, strong) Human* wife;

@property (nonatomic, strong) NSString<Ignore>* stringProperty;
@property (nonatomic, strong) NSString* stringProperty_ignore;
@property (nonatomic, assign) NSInteger intProperty;

@end
