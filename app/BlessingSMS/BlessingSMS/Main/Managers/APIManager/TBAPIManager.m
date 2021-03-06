//
//  TBAPIManager.m
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "TBAPIManager.h"
#import <CommonCrypto/CommonHMAC.h>

#import "IPHelper.h"


#define TB_APPKEY       @"23832822"
#define TB_APPSECRET    @"56f5bd4a4969f98aad2c73e030a308f9"

#define TBAPIUrl  @"http://gw.api.taobao.com/router/rest"

#define ADZONE_ID @"95982835"

@implementation TBAPIManager

+(NSDictionary *)TBAPIBaseParamDic
{
    return @{@"app_key":TB_APPKEY,
             @"timestamp":[[self class] currentDateToStringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
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

+(NSString *)currentDateToStringWithFormat:(NSString *)formatStr
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *format  =  [[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    NSString *dateStr = [format stringFromDate:currentDate];
    return dateStr;
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
    [parameterDic setObject:@(20) forKey:@"page_size"];
    
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

#pragma mark - 宝贝详情API:(获取宝贝详情)
@implementation TB_ItemDetailAPIManager

-(void)getTB_ItemDetailWithId:(NSString *)itemId
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.item.info.get" forKey:@"method"];
    
    [parameterDic setObject:itemId forKey:@"num_iids"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    
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


#pragma mark - 通用物料API:(通用物料)
@implementation TB_MaterialAPIManager

-(void)getTB_MaterialWithId:(NSString *)material_id andPageNum:(NSInteger)pageNum
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.dg.optimus.material" forKey:@"method"];
    
    [parameterDic setObject:@(pageNum) forKey:@"page_no"];
    [parameterDic setObject:@(20) forKey:@"page_size"];
    
    [parameterDic setObject:ADZONE_ID forKey:@"adzone_id"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    [parameterDic setObject:material_id forKey:@"material_id"];
    
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

#pragma mark - 关联推荐API
@implementation TB_ItemRecommendAPIManager

-(void)getTB_MaterialWithId:(NSString *)itemId
{
    //@"5580797"
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.item.recommend.get" forKey:@"method"];
    
    [parameterDic setObject:@(40) forKey:@"count"];
    
    [parameterDic setObject:itemId forKey:@"num_iids"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    
    [parameterDic setObject:@"num_iid,title,pict_url,small_images,reserve_price,zk_final_price,user_type,provcity,item_url,nick,seller_id,volume" forKey:@"fields"];
    
    
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

#pragma mark - 详情API:()
@implementation TB_ItemH5DetailAPIManager

-(void)getTB_ItemDetailWithId:(NSString *)itemId
{
    //@"5580797"
    NSDictionary *dic = @{@"itemNumId":itemId};
    NSString *jsonStr = [dic mj_JSONString];
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)jsonStr,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));

    NSString *baseUrlStr = [NSString stringWithFormat:@"https://h5api.m.taobao.com/h5/mtop.taobao.detail.getdetail/6.0/?data=%@",encodedString];
    
    [self setGETRequestWithEncodeUrlStr:baseUrlStr];
}

-(NSString *)apiMethodName
{
    return NSStringFromClass([self class]);
}

@end

#pragma mark - 通用物料搜索API:()
@implementation TB_SearchMaterialAPIManager

-(void)getTB_SearchMaterialWithPageNum:(NSInteger)pageNum cat:(NSString *)cat searchStr:(NSString *)searchStr complete:(APIManagerComplete)complete{
    self.completeBlock = complete;
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.dg.material.optional" forKey:@"method"];
    [parameterDic setObject:ADZONE_ID forKey:@"adzone_id"];
    
    [parameterDic setObject:@(pageNum) forKey:@"page_no"];
    [parameterDic setObject:@(20) forKey:@"page_size"];
    [parameterDic setObject:@(2) forKey:@"platform"];
    [parameterDic setObject:@"true" forKey:@"has_coupon"];
    
    
    //类别
    if (![NSString isEmpty:cat]) {
        [parameterDic setObject:cat forKey:@"cat"];
    }
    
    //搜索词
    if (![NSString isEmpty:searchStr]) {
        [parameterDic setObject:searchStr forKey:@"q"];
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


#pragma mark - 猜你喜欢API:()
@implementation TB_GuessLikeAPIManager

-(void)getTB_GuessLikeWithPageNum:(NSInteger)pageNum complete:(APIManagerComplete)complete
{
    self.completeBlock = complete;
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.item.guess.like" forKey:@"method"];
    [parameterDic setObject:ADZONE_ID forKey:@"adzone_id"];
    [parameterDic setObject:@(pageNum) forKey:@"page_no"];
    [parameterDic setObject:@(20) forKey:@"page_size"];
    [parameterDic setObject:@"ios" forKey:@"os"];
    
    [parameterDic setObject:[IPHelper getIPAddress:YES] forKey:@"ip"];
    
    NSString *ua = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
    [parameterDic setObject:ua forKey:@"ua"];
    
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        [parameterDic setObject:@"wifi" forKey:@"net"];
    } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
        [parameterDic setObject:@"cell" forKey:@"net"];
    } else {
        [parameterDic setObject:@"unknown" forKey:@"net"];
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

#pragma mark - 淘口令生成API:()
@implementation TB_TKLCreateAPIManager

-(void)getTB_TKLCreateWithTtitle:(NSString *)title url:(NSString *)url logo:(NSString *)logo complete:(APIManagerComplete)complete
{
    self.completeBlock = complete;
    
    NSMutableDictionary *parameterDic = [[NSMutableDictionary alloc]
                                         initWithDictionary:[[self class] TBAPIBaseParamDic]];
    
    [parameterDic setObject:@"taobao.tbk.tpwd.create" forKey:@"method"];
    
    NSString * tempUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,(CFStringRef)@"&",kCFStringEncodingUTF8));
    
    [parameterDic setObject:title forKey:@"text"];
    [parameterDic setObject:tempUrl forKey:@"url"];
    [parameterDic setObject:logo forKey:@"logo"];
    
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
