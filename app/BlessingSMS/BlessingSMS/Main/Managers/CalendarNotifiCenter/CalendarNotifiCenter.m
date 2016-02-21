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

}

-(void)delNotifi:(CalendarNotiModel *)notiModel
{
    
}

@end
