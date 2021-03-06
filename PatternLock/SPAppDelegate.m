//
//  SPAppDelegate.m
//  PatternLock
//
//  Created by justinjing on 15/3/3.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "SPAppDelegate.h"

#import "SPViewController.h"
#import "TestViewController.h"

@implementation SPAppDelegate

@synthesize _ignoreNextApplicationDidBecomeActive;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    self.viewController = [[SPViewController alloc] initWithNibName:@"SPViewController_iPhone" bundle:nil];
	} else {
	    self.viewController = [[SPViewController alloc] initWithNibName:@"SPViewController_iPad" bundle:nil];
	}
 
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    _ignoreNextApplicationDidBecomeActive=NO;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    _ignoreNextApplicationDidBecomeActive=NO;
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
    if (_ignoreNextApplicationDidBecomeActive) {
        return;
    }
	BOOL isPatternSet = ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]) ? YES: NO;
	if(self.window.rootViewController.presentingViewController == nil && isPatternSet){
		TestViewController *lockVc = [[TestViewController alloc]init];
		lockVc.infoLabelStatus = InfoStatusNormal;
        [self.window makeKeyAndVisible];
		[self.window.rootViewController presentViewController:lockVc animated:YES completion:nil];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//http://blog.csdn.net/lgouc/article/details/41675745
@end
