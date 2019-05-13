//
//  HaoWuDetailModel.h
//  BlessingSMS
//
//  Created by hp on 2019/5/11.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HaoWuDetailModel : NSObject


@property (strong, nonatomic) NSString *cat_name;   //一级类目名称 e.女装
@property (strong, nonatomic) NSString *num_iid;     //itemId
@property (strong, nonatomic) NSString *title;              //商品标题
@property (strong, nonatomic) NSString *pict_url;             //商品主图
@property (strong, nonatomic) NSDictionary *small_images;   //商品小图列表 String[]
@property (strong, nonatomic) NSString *reserve_price;   //商品一口价格
@property (strong, nonatomic) NSString *zk_final_price;   //商品折扣价格
@property (strong, nonatomic) NSString *user_type;          //卖家类型，0表示集市（淘宝），1表示商城（天猫）
@property (strong, nonatomic) NSString *provcity;          //商品所在地
@property (strong, nonatomic) NSString *item_url;           //商品详情页链接地址
@property (strong, nonatomic) NSString *seller_id;          //卖家id
@property (strong, nonatomic) NSString *volume;             //30天销量
@property (strong, nonatomic) NSString *nick;               //卖家昵称
@property (strong, nonatomic) NSString *cat_leaf_name;       //子类目名称
@property (strong, nonatomic) NSString *is_prepay;       //是否加入消费者保障
@property (strong, nonatomic) NSString *shop_dsr;       //店铺dsr 评分
@property (strong, nonatomic) NSString *ratesum;       //卖家等级
@property (strong, nonatomic) NSString *i_rfd_rate;       //退款率是否低于行业均值

@property (strong, nonatomic) NSString *h_good_rate;       //好评率是否高于行业均值

@property (strong, nonatomic) NSString *h_pay_rate30;       //成交转化是否高于行业均值
@property (strong, nonatomic) NSString *free_shipment;       //是否包邮

@property (strong, nonatomic) NSString *material_lib_type;         //商品库类型，支持多库类型输出，以“，”区分，1:营销商品主推库

-(NSString *)showImageStr;

@end

NS_ASSUME_NONNULL_END
