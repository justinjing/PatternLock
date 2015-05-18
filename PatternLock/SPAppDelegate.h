//
//  SPAppDelegate.h
//  PatternLock
//
//  Created by justinjing on 15/3/3.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPViewController;

@interface SPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SPViewController *viewController;

@property (assign, nonatomic) BOOL _ignoreNextApplicationDidBecomeActive;
@end
