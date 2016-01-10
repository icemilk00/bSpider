//
//  BaseViewController.h
//  FDCommonFrameWork
//
//  Created by hp on 15/10/22.
//  Copyright (c) 2015年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultNavView.h"

@interface BaseViewController : UIViewController

@end


@interface BaseViewController (SetupDefaultNavView) <DefaultNavDelegate>

-(DefaultNavView *)setupDefaultNavWitConfig:(NSArray *)array;
-(DefaultNavView *)defaultNavView;

@end
