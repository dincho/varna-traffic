//
//  AppDelegate.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 11/30/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIAlertView *internetAlert;

@end

@implementation AppDelegate

@synthesize internetAlert;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityDidChange:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    // Override point for customization after application launch.
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

- (void)reachabilityDidChange:(NSNotification *)notification
{
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        if (self.internetAlert) {
            [self.internetAlert dismissWithClickedButtonIndex:0 animated:YES];
            self.internetAlert = nil;
        }
    } else {
        NSLog(@"Unreachable");
        if (self.internetAlert) {
            return;
        }
        
        self.internetAlert = [[UIAlertView alloc] initWithTitle:@"Липса на интернет връзка!"
                                                        message:@"Това приложение се нуждае от интернет връзка за да функционира"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ];
        [self.internetAlert show];
    }
}

@end
