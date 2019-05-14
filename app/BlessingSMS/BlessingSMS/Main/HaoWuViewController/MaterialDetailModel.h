//
//  MaterialDetailModel.h
//  BlessingSMS
//
//  Created by hp on 2019/5/14.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//物料详情
@interface MaterialDetailModel : NSObject

@property (strong, nonatomic) NSString *coupon_amount;   //优惠券信息-优惠券面额。
@property (strong, nonatomic) NSDictionary *small_images;   //商品小图列表 String[]
@property (strong, nonatomic) NSString *shop_title;         //店铺名称
@property (strong, nonatomic) NSString *category_id;         //商品信息-叶子类目id
@property (strong, nonatomic) NSString *coupon_start_fee;  //优惠券信息-优惠券起用门槛，满X元可用。如：满299元减20元
@property (strong, nonatomic) NSString *item_id;         //商品信息-宝贝id
@property (strong, nonatomic) NSString *coupon_total_count;         //优惠券信息-优惠券总量
@property (strong, nonatomic) NSString *user_type;          //卖家类型，0表示集市（淘宝），1表示商城（天猫）
@property (strong, nonatomic) NSString *zk_final_price;   //商品折扣价格
@property (strong, nonatomic) NSString *coupon_remain_count;   //优惠券信息-优惠券剩余量
@property (strong, nonatomic) NSString *commission_rate;   //商品信息-佣金比率(%)
@property (strong, nonatomic) NSString *coupon_start_time;     //优惠券开始时间
@property (strong, nonatomic) NSString *title;              //商品标题
@property (strong, nonatomic) NSString *item_description;     //宝贝描述（推荐理由）
@property (strong, nonatomic) NSString *seller_id;          //卖家id
@property (strong, nonatomic) NSString *volume;             //30天销量
@property (strong, nonatomic) NSString *coupon_end_time;     //优惠券结束时间
@property (strong, nonatomic) NSString *pict_url;             //商品主图
@property (strong, nonatomic) NSString *click_url;             //链接-宝贝推广链接

@property (strong, nonatomic) NSString *stock;             //拼团专用-拼团剩余库存
@property (strong, nonatomic) NSString *sell_num;             //拼团专用-拼团已售数量
@property (strong, nonatomic) NSString *total_stock;             //拼团专用-拼团库存数量
@property (strong, nonatomic) NSString *oetime;             //拼团专用-拼团结束时间
@property (strong, nonatomic) NSString *ostime;             //拼团专用-拼团开始时间
@property (strong, nonatomic) NSString *jdd_num;             //拼团专用-拼团几人团
@property (strong, nonatomic) NSString *jdd_price;             //拼团专用-拼团拼成价，单位元
@property (strong, nonatomic) NSString *orig_price;             //拼团专用-拼团一人价（原价)，单位元
@property (strong, nonatomic) NSString *level_one_category_name;             //商品信息-一级类目名称
@property (strong, nonatomic) NSString *level_one_category_id;             //商品信息-一级类目ID
@property (strong, nonatomic) NSString *category_name;             //商品信息-叶子类目名称
@property (strong, nonatomic) NSString *white_image;             //商品信息-商品白底图
@property (strong, nonatomic) NSString *short_title;             //商品信息-商品短标题
@property (strong, nonatomic) NSDictionary *word_list;             //商品信息-商品关联词
@property (strong, nonatomic) NSString *tmall_play_activity_info;             //营销-天猫营销玩法 前n件x折
@property (strong, nonatomic) NSString *uv_sum_pre_sale;            //商品信息-预售数量
//@property (strong, nonatomic) NSString *new_user_price;             //商品信息-新人价
@property (strong, nonatomic) NSString *coupon_info;             //优惠券信息-优惠券满减信息
@property (strong, nonatomic) NSString *coupon_share_url;             //链接-宝贝+券二合一页面链接
@property (strong, nonatomic) NSString *nick;              //店铺信息-卖家昵称
@property (strong, nonatomic) NSString *reserve_price;     //商品信息-一口价

-(NSString *)showImageStr;

@end

NS_ASSUME_NONNULL_END
