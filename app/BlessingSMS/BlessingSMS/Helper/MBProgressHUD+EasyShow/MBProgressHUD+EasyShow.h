//
//  MBProgressHUD+EasyShow.h
//  BlessingSMS
//
//  Created by hp on 16/1/16.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "MBProgressHUD.h"

#define HUD_SHOW_TIME 1.0

@interface MBProgressHUD (EasyShow)
+(void)showHUDWithTitle:(NSString *)title;
+(void)showHUDWithTitle:(NSString *)title withView:(UIView *)view;
+(void)hiddenHUDLoadingForView:(UIView *)view animated:(BOOL)animated;
@end
