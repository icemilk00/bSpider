//
//  CalendarNotiModel.h
//  BlessingSMS
//
//  Created by hp on 16/2/21.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDataModel.h"

@interface CalendarNotiModel : NSObject

@property (nonatomic, strong) NSString *notiContent;
@property (nonatomic, strong) CalendarDataModel *calendarModel;
@property (nonatomic, strong) NSString *notiTimeStr;
@property (nonatomic, assign) BOOL isNeedNoti;

//-(NSMutableDictionary *)mutableDic;

@end
