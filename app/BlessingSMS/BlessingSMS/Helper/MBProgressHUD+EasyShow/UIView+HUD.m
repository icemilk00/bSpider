//
//  UIView+HUD.m
//  YGQQ
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 山西大德通科技有限公司. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)

- (void)showHud {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        /**************************/
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        /**************************/
    }
}

- (void)hideHud {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    [self bringSubviewToFront:hud];
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showHudWithMessage:(NSString *)messge {
    [self showHudWithMessage:messge automaticallyHide:YES];
}

- (void)showHudWithMessage:(NSString *)messge automaticallyHide:(BOOL)hide {
    [self showHudWithMessage:messge automaticallyHide:hide delay:2.0];
}

- (void)showHudWithMessage:(NSString *)messge automaticallyHide:(BOOL)hide delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        /**************************/
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        /**************************/
    }
    if (messge) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = hud.label.font;
        hud.detailsLabel.text = messge;
    }
    if (hide) {
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:delay];
    }
}

- (void)showHudWithMessage:(NSString *)messge delay:(NSTimeInterval)delay {
    [self showHudWithMessage:messge automaticallyHide:YES delay:delay];
}

- (void)hideHudWithMessage:(NSString *)message {
    [self hideHudWithMessage:message delay:2.0];
}

- (void)hideHudWithMessage:(NSString *)message delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (hud) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = hud.label.font;
        hud.detailsLabel.text = message;
        /**************************/
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        /**************************/
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:delay];
    }
}

@end

