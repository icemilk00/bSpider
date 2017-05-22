//
//  AboutSMSViewController.m
//  BlessingSMS
//
//  Created by hp on 16/2/27.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "AboutSMSViewController.h"

@interface AboutSMSViewController ()

@end

@implementation AboutSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
    
    [self setupDefaultNavWitConfig:@[KeyLeftButton]];
    
    // app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appVersion = [NSString stringWithFormat:@"%@.%@", app_Version, app_build];
    
    self.versionLabel.text =  appVersion;
}

-(void)navLeftButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
