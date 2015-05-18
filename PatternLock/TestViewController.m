//
//  TestViewController.m
//  PatternLock
//
//  Created by justinjing on 15/3/3.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "TestViewController.h"
#import "NormalCircle.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SPAppDelegate.h"
@interface TestViewController ()<LockScreenDelegate>

@property (nonatomic) NSInteger wrongGuessCount;
@end

@implementation TestViewController
@synthesize infoLabelStatus,wrongGuessCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"locus_bg_iphone5"]];
 
}

-(void)openTouchID{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        return;
    }
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"通过指纹解锁app进入";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        ((SPAppDelegate *)[[UIApplication sharedApplication] delegate])._ignoreNextApplicationDidBecomeActive=YES;
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSString *message = @"其他错误";
                                        if (error.code == kLAErrorUserFallback) {
                                            message = @"用户选择密码输入";
                                        }else if (error.code == kLAErrorUserCancel){
                                            message = @"用户取消验证";
                                        }else if (error.code == kLAErrorSystemCancel){
                                            message = @"系统取消验证";
                                        }
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                                            message:message
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        [alertView show];
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = @"未知错误";
            if (authError) {
                
                if (authError.code == kLAErrorPasscodeNotSet) {
                    //为设置密码与指纹
                    message = @"用户未设置密码";
                }else if(authError.code == kLAErrorTouchIDNotEnrolled){
                    //未设置指纹
                    message = @"用户未设置指纹";
                }else if(authError.code == kLAErrorTouchIDNotAvailable){
                    message = @"设备不支持指纹";
                }
            }

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:authError.description
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
   
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.lockScreenView = [[SPLockScreen alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
	self.lockScreenView.center = self.view.center;
	self.lockScreenView.delegate = self;
	self.lockScreenView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.lockScreenView];
	
	self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 20)];
	self.infoLabel.backgroundColor = [UIColor clearColor];
	self.infoLabel.font = [UIFont systemFontOfSize:16];
	self.infoLabel.textColor = [UIColor whiteColor];
	self.infoLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.infoLabel];
	
	[self updateOutlook];

}


- (void)updateOutlook
{
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			self.infoLabel.text = @"设置手势密码!";
			break;
		case InfoStatusConfirmSetting:
			self.infoLabel.text = @"确定手势密码!";
			break;
		case InfoStatusFailedConfirm:
			self.infoLabel.text = @"二次输入不一致,请重试";
			break;
		case InfoStatusNormal:
			self.infoLabel.text = @"请输入手势密码解锁";
            [self openTouchID];
			break;
		case InfoStatusFailedMatch:
			self.infoLabel.text = [NSString stringWithFormat:@"输入错误%ld次, 请重试!",(long)self.wrongGuessCount];
			break;
		case InfoStatusSuccessMatch:
			self.infoLabel.text = @"欢迎使用!";
			break;
			
		default:
			break;
	}
	
}


#pragma -LockScreenDelegate

- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
	NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			[stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusFailedConfirm:
			[stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusConfirmSetting:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPatternTemp]]) {
				[stdDefault setValue:patternNumber forKey:kCurrentPattern];
				[self dismissViewControllerAnimated:YES completion:nil];
			}
			else {
				self.infoLabelStatus = InfoStatusFailedConfirm;
				[self updateOutlook];
			}
			break;
		case  InfoStatusNormal:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]])
                [self dismissViewControllerAnimated:YES completion:nil];
			else {
				self.infoLabelStatus = InfoStatusFailedMatch;
				self.wrongGuessCount ++;
				[self updateOutlook];
			}
			break;
		case InfoStatusFailedMatch:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]]) [self dismissViewControllerAnimated:YES completion:nil];
			else {
				self.wrongGuessCount ++;
				self.infoLabelStatus = InfoStatusFailedMatch;
				[self updateOutlook];
			}
			break;
		case InfoStatusSuccessMatch:
			[self dismissViewControllerAnimated:YES completion:nil];
			break;
			
		default:
			break;
	}
}

- (void)viewDidUnload {
	[self setInfoLabel:nil];
	[self setLockScreenView:nil];
	[super viewDidUnload];
}
@end
