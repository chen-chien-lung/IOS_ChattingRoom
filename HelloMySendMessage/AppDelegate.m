//
//  AppDelegate.m
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/17.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "Communicator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Ask user's permission
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeSound |UIUserNotificationTypeBadge;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    
    [application registerUserNotificationSettings:settings];
    //Ask deviceToken
    [application registerForRemoteNotifications];
    
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"DeviceToken %@",deviceToken.description);
    
    
    NSString * finalDeviceToken = deviceToken.description;
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"finalDeviceToken:%@",finalDeviceToken);
    
    //Update DeviceToken to Server
    Communicator * comm = [Communicator shareInstance];
    
    [comm updateDeviceToken:finalDeviceToken completion:^(NSError *error, id result) {
        
    }];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}

//收到server傳來的notification
//再通知點取收到的推播時和使用app時收到推播就會觸發這個方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"* didReceiveRemoteNotification: %@",userInfo.description);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DID_RECEIVED_REMOTE_NOTIFICATION object:nil];
    
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"* didReceiveRemoteNotification: %@",userInfo.description);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:DID_RECEIVED_REMOTE_NOTIFICATION object:nil];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
