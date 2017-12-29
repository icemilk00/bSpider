//
//  ActivityManager.m
//
//
//  Created by mac on 2017/12/29.
//

#import "ActivityManager.h"
#import "ActivityShowView.h"

@interface ActivityManager()

@end

@implementation ActivityManager

+ (instancetype)shareInstance {
    static ActivityManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [ActivityManager new];
    });
    return obj;
}

-(void)showAlert
{
    ActivityShowView *showView = [[[NSBundle mainBundle] loadNibNamed:@"ActivityShowView" owner:self options:nil] lastObject];
    showView.showStr = _showStr;
    [showView show];
}


@end
