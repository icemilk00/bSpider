//
//  TBAPIManager.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "TBAPIManager.h"

#define TB_APPKEY       @"23832822"
#define TB_APPSECRET    @"56f5bd4a4969f98aad2c73e030a308f9"

#define TBAPIUrl  @"http://gw.api.taobao.com/router/rest"

#define ADZONE_ID @"95982835"

@implementation TBAPIManager

+(NSDictionary *)TBAPIBaseParamDic
{
    return @{@"app_key":TB_APPKEY,
             @"timestamp":[DateHelper currentDateToStringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
             @"v":@"2.0",
             @"sign_method":@"md5",
             @"format":@"json"};
}


+(NSString *)signForTBAPIWithParamDic:(NSDictionary *)paramDic
{
    NSArray *parameterArray = [paramDic allKeys];
    NSArray *resultArray = [parameterArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        return [obj1 compare:obj2]; //升序
    }];
    NSLog(@"result=%@",resultArray);
    
    NSMutableString *signSourceStr = [[NSMutableString alloc] init];
    for (NSString *keyStr in resultArray) {
        NSString *valueStr = paramDic[keyStr];
        [signSourceStr appendString:[NSString stringWithFormat:@"%@%@",keyStr,valueStr]];
    }
    
    NSLog(@"signSourceStr=%@",signSourceStr);
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",TB_APPSECRET, signSourceStr, TB_APPSECRET];
    const char *cStr = [signStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSString *sign = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    return sign;
}

@end


#pragma mark - 淘宝客API:(获取淘宝联盟选品库的宝贝信息)
@implementation TB_FavoritesItemAPIManager

-(void)getTB_FavoritesItem:(NSString *)itemID andPageNum:(NSInteger)pageNum
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.uatm.favorites.item.get" forKey:@"method"];
    
    [parameterDic setObject:itemID forKey:@"favorites_id"];
    [parameterDic setObject:ADZONE_ID forKey:@"adzone_id"];
    [parameterDic setObject:@(pageNum) forKey:@"page_no"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    [parameterDic setObject:@"num_iid,title,Cpict_url,small_images,reserve_price,zk_final_price,user_type,provcity,item_url,seller_id,volume,nick,shop_title,zk_final_price_wap,event_start_time,event_end_time,tk_rate,status,type,click_url" forKey:@"fields"];

    NSString *sign = [[self class] signForTBAPIWithParamDic:parameterDic];
    [parameterDic setObject:sign forKey:@"sign"];
    

    NSString *paramStr = [[self class] paramStrForDic:parameterDic];
    //    NSString *baseUrlStr = @"http://gw.api.taobao.com/router/rest?sign=D3C05213CE66AF1325729B80F460F38C&timestamp=2017-05-19+18%3A06%3A42&v=2.0&app_key=23832822&method=taobao.tbk.uatm.favorites.item.get&partner_id=top-apitools&format=json&adzone_id=95982835&platform=2&favorites_id=5580797&force_sensitive_param_fuzzy=true&fields=num_iid%2Ctitle%2Cpict_url%2Csmall_images%2Creserve_price%2Czk_final_price%2Cuser_type%2Cprovcity%2Citem_url%2Cseller_id%2Cvolume%2Cnick%2Cshop_title%2Czk_final_price_wap%2Cevent_start_time%2Cevent_end_time%2Ctk_rate%2Cstatus%2Ctype%2Cclick_url";
    NSString *baseUrlStr = [NSString stringWithFormat:@"%@?%@", TBAPIUrl, paramStr];
    
    [self setGETRequestWithUrlStr:baseUrlStr];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end

#pragma mark - 淘宝客API:(获取淘宝联盟选品库的宝贝信息)
@implementation TB_FavoritesListAPIManager

-(void)getTB_FavoritesList
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.uatm.favorites.get" forKey:@"method"];
    
    [parameterDic setObject:@(1) forKey:@"page_no"];
    [parameterDic setObject:@(100) forKey:@"page_size"];
    
    [parameterDic setObject:@"favorites_title,favorites_id,type" forKey:@"fields"];
    
    NSString *sign = [[self class] signForTBAPIWithParamDic:parameterDic];
    [parameterDic setObject:sign forKey:@"sign"];
    
    NSString *paramStr = [[self class] paramStrForDic:parameterDic];
    NSString *baseUrlStr = [NSString stringWithFormat:@"%@?%@", TBAPIUrl, paramStr];
    
    [self setGETRequestWithUrlStr:baseUrlStr];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end


#pragma mark - 好卷清单API:(获取淘宝客优惠券)
@implementation TB_JuanListAPIManager

-(void)getTB_JuanListWithCat:(NSString *)cat searchStr:(NSString *)q andPageNum:(NSInteger)pageNum
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.dg.item.coupon.get" forKey:@"method"];
    
    [parameterDic setObject:@(pageNum) forKey:@"page_no"];
    [parameterDic setObject:@(30) forKey:@"page_size"];
    
    [parameterDic setObject:ADZONE_ID forKey:@"adzone_id"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    
    if (![NSString isEmpty:q]) {
        [parameterDic setObject:q forKey:@"q"];      //查询词，用于搜索
    }
    
    if (![NSString isEmpty:cat]) {
        [parameterDic setObject:cat forKey:@"cat"];    //分类
    }
    
    NSString *sign = [[self class] signForTBAPIWithParamDic:parameterDic];
    [parameterDic setObject:sign forKey:@"sign"];
    
    NSString *paramStr = [[self class] paramStrForDic:parameterDic];
    NSString *baseUrlStr = [NSString stringWithFormat:@"%@?%@", TBAPIUrl, paramStr];
    
    [self setGETRequestWithUrlStr:baseUrlStr];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end
