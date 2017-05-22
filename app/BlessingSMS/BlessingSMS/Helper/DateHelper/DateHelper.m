//
//  DateHelper.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(NSString *)currentDateToStringWithFormat:(NSString *)formatStr
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *format  =  [[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    NSString *dateStr = [format stringFromDate:currentDate];
    return dateStr;
}

@end
