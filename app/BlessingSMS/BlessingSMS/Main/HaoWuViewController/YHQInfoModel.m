//
//  YHQInfoModel.m
//  BlessingSMS
//
//  Created by hp on 2019/5/10.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "YHQInfoModel.h"

@implementation YHQInfoModel
-(NSString *)showImageStr
{
    if (_small_images == nil) {
        return @"";
    }
    
    NSArray *array = _small_images[@"string"];
    if (!array || array.count == 0) {
        return @"";
    }
    
    return array[0];
}

-(NSString *)juanPrice {
    NSString *juanStr = self.coupon_info;
    NSArray *strArray = [juanStr componentsSeparatedByString:@"减"];
    juanStr = strArray[1];
    juanStr = [juanStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    return juanStr;
}
@end
