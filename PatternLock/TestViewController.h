//
//  TestViewController.h
//  PatternLock
//
//  Created by justinjing on 15/3/3.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPLockScreen.h"

typedef enum {
	InfoStatusFirstTimeSetting = 0,
	InfoStatusConfirmSetting,
	InfoStatusFailedConfirm,
	InfoStatusNormal,
	InfoStatusFailedMatch,
	InfoStatusSuccessMatch
}	InfoStatus;


@interface TestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet SPLockScreen *lockScreenView;
@property (nonatomic) InfoStatus infoLabelStatus;

@end
