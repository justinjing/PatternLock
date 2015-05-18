//
//  SPViewController.m
//  PatternLock
//
//  Created by justinjing on 15/3/3.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "SPViewController.h"
#import "TestViewController.h"

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(doPattern)];
}

- (void) doPattern
{
		TestViewController *lockVc = [[TestViewController alloc]init];
		lockVc.infoLabelStatus = InfoStatusFirstTimeSetting;
		[self.navigationController presentViewController:lockVc animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
