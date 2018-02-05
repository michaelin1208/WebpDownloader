//
//  AppDelegate.m
//  webpDownloader
//
//  Created by Michaelin on 2017/10/18.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self read];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground %@",self.webPs);
    //获取应用程序沙盒的Documents目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"webPs.plist"];
//    //输入写入
//    [self.webPs writeToFile:filename atomically:YES];
    [self saveArray];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    [self read];
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"webPs" ofType:@"plist"];
//    self.webPs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", self.webPs);//直接打印数据。
    
}

- (void)saveArray
{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.新建数据
    
    
    NSString *filepath = [docPath stringByAppendingPathComponent:@"webPs.plist"];
    NSLog(@"write path: %@",filepath);
    [[self.webPs copy] writeToFile:filepath atomically:YES];
}

- (IBAction)read {
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    
    // 3.文件路径
    NSString *filepath = [docPath stringByAppendingPathComponent:@"webPs.plist"];
    
    NSLog(@"read path: %@",filepath);
    // 4.读取数据
    self.webPs = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filepath]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
