//
//  CalendarNotifiCenter.m
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarNotifiCenter.h"

@implementation CalendarNotifiCenter

static CalendarNotifiCenter *calendarNotifiCenter = nil;

+(CalendarNotifiCenter *)defaultCenter
{
    @synchronized (self)
    {
        if (calendarNotifiCenter == nil) {
            calendarNotifiCenter = [[self alloc] init];
        }
    }
    
    return calendarNotifiCenter;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (calendarNotifiCenter == nil) {
            calendarNotifiCenter = [super allocWithZone:zone];
            return  calendarNotifiCenter;
        }
    }
    return nil;
}

-(void)addNotifi:(CalendarNotiModel *)notiModel
{
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)notiModel.calendarModel.year, (unsigned long)notiModel.calendarModel.month, (unsigned long)notiModel.calendarModel.day];
    
    [[DataStore dataStoreWithName:CALENDAR_NOTI] addObject:notiModel forKey:saveKey];
}

-(void)delNotifi:(CalendarNotiModel *)notiModel
{
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)notiModel.calendarModel.year, (unsigned long)notiModel.calendarModel.month, (unsigned long)notiModel.calendarModel.day];
    [[DataStore dataStoreWithName:CALENDAR_NOTI] removeObject:notiModel ForKey:saveKey];
}

-(NSDictionary *)calendarNotiDic
{
    NSLog(@"%@", [[DataStore dataStoreWithName:CALENDAR_NOTI] dictonary]);
    return [[DataStore dataStoreWithName:CALENDAR_NOTI] dictonary];
}

@end
