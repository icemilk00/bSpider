//
//  SMSInfoModel.m
//  BlessingSMS
//
//  Created by hp on 15/12/31.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "SMSInfoModel.h"

@implementation SMSInfoModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.category_id = dic[@"category_id"];
        self.content = dic[@"content"];
        self.id = dic[@"id"];
        self.created_at = dic[@"created_at"];
        self.category_name = dic[@"category_name"];
    }
    return self;
}

@end

@implementation SMSInfoReformer

-(id)manager:(BaseAPIManager *)manager reformData:(NSDictionary *)data
{
    if ([manager isKindOfClass:[SMSAPIManager class]]) {
        return [self smsInfoWithData:data];
    }
    return nil;
}

-(NSArray *)smsInfoWithData:(NSDictionary *)data
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSArray *dataArray = data[@"sms"];
    for (NSDictionary *dic in dataArray) {
        SMSInfoModel *model = [[SMSInfoModel alloc] initWithDic:dic];
        [resultArray addObject:model];
    }
    
    return [resultArray mutableCopy];
}

@end