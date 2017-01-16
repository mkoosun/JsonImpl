//
//  KOAppDelegate.m
//  JsonImpl
//
//  Created by mkoo.sun on 01/14/2017.
//  Copyright (c) 2017 mkoo.sun. All rights reserved.
//

#import "KOAppDelegate.h"
#import "Man.h"

@implementation KOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSDictionary *dict = @{
                           @"age":@30,
                           @"name":@"mkoo",
                           @"birthDay":@"1984",
                           @"likes":@[@"basketball", @"swim"],
                           @"wife":@{
                                   @"age":@30,
                                   @"name":@"yao",
                                   @"birthDay":@"1982",
                                   @"likes":@[@"movie"]
                                   },
                           @"childrens": @[
                                   @{
                                       @"age":@4,
                                       @"name":@"swy",
                                       @"birthDay":@"2012",
                                       @"likes":@[@"run"]
                                       }
                                   ],
                           @"friends":@[
                                   @{
                                       @"name":@"myfriend1",
                                       @"birthDay":@"1982",
                                       }],
                           };
    
    Man *man = [Man new];
    
    man.stringProperty = @"ignore me";
    man.stringProperty_ignore = @"ignore me";
    man.intProperty = 10000;
    [man parse:dict];
    
    NSString *str = [man toJsonString];
    
    NSLog(@"%@", str);
    
    Man *man2 = [Man new];
    [man2 parse:str];
    
    NSString *str2 = [man2 toJsonString];
    
    NSLog(@"%@", str2);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
