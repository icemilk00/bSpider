//
//  MBProgressHUD+EasyShow.m
//  BlessingSMS
//
//  Created by hp on 16/1/16.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "MBProgressHUD+EasyShow.h"

@implementation MBProgressHUD (EasyShow)

+ (void)showHUDWithImageWithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay
{
    
    AppDelegate *appDelegate =  APPDELEGATE;
    
    MBProgressHUD *myHud = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
    [appDelegate.window addSubview:myHud];
    
    myHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    myHud.mode =  MBProgressHUDModeCustomView;
    myHud.labelText = title;
    
    
    [myHud showAnimated:YES whileExecutingBlock:^{
        sleep(delay);
    } completionBlock:^{
        [myHud removeFromSuperview];
        
    }];
}

+(void)showHUDWithTitle:(NSString *)title
{
    [MBProgressHUD showHUDWithTitle:title withHiddenDelay:HUD_SHOW_TIME];;
}

+(void)showHUDWithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay
{
//    ((RESideMenu *)APPDELEGATE.window.rootViewController).contentViewController.navigationController.view
    [MBProgressHUD showHUDWithImgWithTitle:title withHiddenDelay:delay withView:APPDELEGATE.window];
}

+(void)showHUDWithTitle:(NSString *)title withView:(UIView *)view
{
    [MBProgressHUD showHUDWithImgWithTitle:title withHiddenDelay:HUD_SHOW_TIME withView:view];
}

+(void)showHUDWithImgWithTitle:(NSString *)title withHiddenDelay:(NSTimeInterval)delay withView:(UIView *)view
{
    [MBProgressHUD hiddenAllHUDForView:APPDELEGATE.window animated:NO];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(delay);
    } completionBlock:^{
        [hud removeFromSuperview];
        
    }];
    
}

+(MBProgressHUD *)showHUDWithLoadingWithTitle:(NSString *)title withView:(UIView *)view animated:(BOOL)animated
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    
    //    hud.dimBackground = YES;
    hud.labelText = title;
    
    return hud;
    
}

+(void)hiddenHUDLoadingForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+(void)hiddenAllHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

@end
