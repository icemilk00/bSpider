//
//  CalendarNotifiCenter.h
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarNotiModel.h"

#define CALENDAR_NOTI  @"CalendatNoti"

@interface CalendarNotifiCenter : NSObject

+(CalendarNotifiCenter *)defaultCenter;

-(void)addNotifi:(CalendarNotiModel *)notiModel;
-(void)delNotifi:(CalendarNotiModel *)notiModel;
-(void)editNotifi:(CalendarNotiModel *)notiModel withIndex:(NSInteger)editIndex;

//key : year|month|day
-(NSMutableArray *)calendarNotiDicWithKey:(NSString *)key;
@end
