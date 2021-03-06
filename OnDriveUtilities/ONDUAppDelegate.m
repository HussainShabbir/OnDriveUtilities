//
//  AppDelegate.m
//  OnDriveUtilities
//
//  Created by Hussain Shabbir on 5/15/16.
//  Copyright © 2016 Hussain Shabbir. All rights reserved.
//

#import "ONDUAppDelegate.h"
#import <EventKit/EventKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface ONDUAppDelegate ()
@property (nonatomic, strong) CTCallCenter* callCenter;
@property (nonatomic) BOOL callWasStarted;
@end

@implementation ONDUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    return YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication]cancelLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    @try
    {
        UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
        id vwControllers = navigationController.viewControllers;
        if ([vwControllers count] > 1){
            for (NSUInteger i = 0; i< [vwControllers count]; i++)
            {
                [navigationController popViewControllerAnimated:YES];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception=%@",exception.reason);
    }
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
