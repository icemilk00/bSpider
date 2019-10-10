//
//  UIView+HUD.h
//  YGQQ
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 山西大德通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

- (void)showHud;

- (void)hideHud;

- (void)showHudWithMessage:(NSString *)messge;

- (void)showHudWithMessage:(NSString *)messge automaticallyHide:(BOOL)hide;

- (void)showHudWithMessage:(NSString *)messge automaticallyHide:(BOOL)hide delay:(NSTimeInterval)delay;

- (void)showHudWithMessage:(NSString *)messge delay:(NSTimeInterval)delay;

- (void)hideHudWithMessage:(NSString *)message;

- (void)hideHudWithMessage:(NSString *)message delay:(NSTimeInterval)delay;

@end

