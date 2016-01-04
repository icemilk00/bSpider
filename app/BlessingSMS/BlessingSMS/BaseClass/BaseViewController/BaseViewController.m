//
//  BaseViewController.m
//  FDCommonFrameWork
//
//  Created by hp on 15/10/22.
//  Copyright (c) 2015年 hxp. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


@implementation BaseViewController (SetupDefaultNavView)

-(DefaultNavView *)setupDefaultNavWitConfig:(NSArray *)array
{
    DefaultNavView *defaultNav = [[DefaultNavView alloc] initWithConfig:array];
    defaultNav.title = self.title;
    defaultNav.defaultNavDelegate = self;
    [self.view addSubview:defaultNav];
    return defaultNav;
}

-(DefaultNavView *)defaultNavView
{
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[DefaultNavView class]]) {
            return (DefaultNavView *)subView;
        }
    }
    return nil;
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    DefaultNavView *navView = [self defaultNavView];
    if (navView) {
        navView.title = title;
    }
}

@end
