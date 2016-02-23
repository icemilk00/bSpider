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
    
    [[DataStore dataStoreWithName:CALENDAR_NOTI] addObject:notiModel.mj_keyValues forKey:saveKey];
}

-(void)delNotifi:(CalendarNotiModel *)notiModel
{
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)notiModel.calendarModel.year, (unsigned long)notiModel.calendarModel.month, (unsigned long)notiModel.calendarModel.day];
    [[DataStore dataStoreWithName:CALENDAR_NOTI] removeObject:notiModel.mj_keyValues ForKey:saveKey];
}

-(void)editNotifi:(CalendarNotiModel *)notiModel withIndex:(NSInteger)editIndex
{
    NSString *saveKey = [NSString stringWithFormat:@"%lu|%lu|%lu", (unsigned long)notiModel.calendarModel.year, (unsigned long)notiModel.calendarModel.month, (unsigned long)notiModel.calendarModel.day];
    
    [[DataStore dataStoreWithName:CALENDAR_NOTI] editObject:notiModel.mj_keyValues ForKey:saveKey withIndex:editIndex];
}

-(NSMutableArray *)calendarNotiDicWithKey:(NSString *)key
{
    NSMutableDictionary *mtDic = [[DataStore dataStoreWithName:CALENDAR_NOTI] dictonary];
    NSMutableArray *dicArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = mtDic[key];
    if (tempArray) {
        for (NSMutableDictionary * dic in tempArray) {
            CalendarNotiModel *notiModel = [CalendarNotiModel mj_objectWithKeyValues:dic];
            [dicArray addObject:notiModel];
        }
    }
    
    return dicArray;
}

@end
