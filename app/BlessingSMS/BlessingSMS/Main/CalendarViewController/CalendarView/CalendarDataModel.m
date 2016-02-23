//
//  CalendarDataModel.m
//  CalendarDemo
//
//  Created by hp on 16/2/18.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarDataModel.h"

@implementation CalendarDataModel


+ (CalendarDataModel *)calendarModuleWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    CalendarDataModel *calendarModule = [[CalendarDataModel alloc] init];
    calendarModule.year = year;
    calendarModule.month = month;
    calendarModule.day = day;
    return calendarModule;
}

- (BOOL)isEqualTo:(CalendarDataModel *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

//-(NSMutableDictionary *)mutableDic
//{
//    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
//    
//    mutableDic[@"day"] = [NSNumber numberWithInteger:self.day];
//    mutableDic[@"month"] = [NSNumber numberWithInteger:self.month];
//    mutableDic[@"year"] = [NSNumber numberWithInteger:self.year];
//    
//    return mutableDic;
//}

@end
