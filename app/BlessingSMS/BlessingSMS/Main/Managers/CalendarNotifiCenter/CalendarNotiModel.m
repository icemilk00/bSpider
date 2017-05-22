//
//  CalendarNotiModel.m
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarNotiModel.h"

@implementation CalendarNotiModel


-(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *pushDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %@", (unsigned long)self.calendarModel.year, (unsigned long)self.calendarModel.month, (unsigned long)self.calendarModel.day, self.notiTimeStr]];
    
    return pushDate;
}
//-(NSMutableDictionary *)mutableDic
//{
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
//    
//    mutableDic[@"notiContent"] = self.notiContent;
//    mutableDic[@"calendarModel"] = [self.calendarModel mutableDic];
//    mutableDic[@"notiTimeStr"] = self.notiTimeStr;
//    mutableDic[@"isNeedNoti"] = [NSNumber numberWithBool:self.isNeedNoti];
//    
//    return mutableDic;
//}

@end
