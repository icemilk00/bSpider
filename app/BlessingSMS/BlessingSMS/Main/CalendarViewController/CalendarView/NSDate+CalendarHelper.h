//
//  NSDate+CalendarHelper.h
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreFoundation/CFCalendar.h>

@interface NSDate (CalendarHelper)

- (NSUInteger)numberOfWeeksInCurrentMonth;
- (NSUInteger)weeklyOrdinality;
- (NSString *)weeklyOrdinalityStr;
- (NSDate *)firstDayInCurrentMonth;
- (NSUInteger)numberOfDaysInCurrentMonth;
- (NSDate *)lastDayOfCurrentMonth;
- (NSDate *)dayInThePreviousMonth;
- (NSDate *)dayInTheFollowingMonth;
- (NSDateComponents *)YMDComponents;
- (NSUInteger)weekNumberInCurrentMonth;

- (NSString *)chineseCalendar;
-(NSString *)getChineseHoliday;
-(NSString *)getWorldHoliday;

-(BOOL)isBeforeCurrentDate;
@end
