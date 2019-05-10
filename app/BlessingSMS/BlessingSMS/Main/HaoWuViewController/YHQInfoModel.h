//
//  YHQInfoModel.h
//  BlessingSMS
//
//  Created by hp on 2019/5/10.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHQInfoModel : NSObject

@property (strong, nonatomic) NSDictionary *small_images;   //商品小图列表 String[]
@property (strong, nonatomic) NSString *shop_title;         //店铺名称
@property (strong, nonatomic) NSString *user_type;          //卖家类型，0表示集市（淘宝），1表示商城（天猫）
@property (strong, nonatomic) NSString *zk_final_price;     //折扣价
@property (strong, nonatomic) NSString *title;              //商品标题
@property (strong, nonatomic) NSString *nick;               //卖家昵称
@property (strong, nonatomic) NSString *seller_id;          //卖家id
@property (strong, nonatomic) NSString *volume;             //30天销量
@property (strong, nonatomic) NSString *pict_url;             //商品主图
@property (strong, nonatomic) NSString *item_url;           //商品详情页链接地址
@property (strong, nonatomic) NSString *coupon_total_count; //优惠券总量
@property (strong, nonatomic) NSString *commission_rate;    //佣金比率(%)
@property (strong, nonatomic) NSString *coupon_info;    //优惠券面额 - 满16元减10元
@property (strong, nonatomic) NSString *category;    //后台一级类目
@property (strong, nonatomic) NSString *num_iid;     //itemId
@property (strong, nonatomic) NSString *coupon_remain_count;     //优惠券剩余量
@property (strong, nonatomic) NSString *coupon_start_time;     //优惠券开始时间
@property (strong, nonatomic) NSString *coupon_end_time;     //优惠券结束时间
@property (strong, nonatomic) NSString *coupon_click_url;     //商品优惠券推广链接
@property (strong, nonatomic) NSString *item_description;     //宝贝描述（推荐理由）
-(NSString *)showImageStr;
@end

NS_ASSUME_NONNULL_END
