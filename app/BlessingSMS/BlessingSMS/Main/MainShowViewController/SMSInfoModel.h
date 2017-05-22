//
//  SMSInfoModel.h
//  BlessingSMS
//
//  Created by hp on 15/12/31.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSInfoModel : NSObject

-(id)initWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *category_name;

@end

#pragma mark - 处理sms信息的reformer
@interface SMSInfoReformer : DataReformer

@end