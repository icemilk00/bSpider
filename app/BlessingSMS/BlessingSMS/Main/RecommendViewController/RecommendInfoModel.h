//
//  RecommendInfoModel.h
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendInfoModel : NSObject

@property (strong, nonatomic) NSString *click_url;
@property (strong, nonatomic) NSString *event_end_time;
@property (strong, nonatomic) NSString *event_start_time;
@property (strong, nonatomic) NSString *item_url;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *num_iid;
@property (strong, nonatomic) NSString *provcity;
@property (strong, nonatomic) NSString *reserve_price;
@property (strong, nonatomic) NSString *seller_id;
@property (strong, nonatomic) NSString *shop_title;
@property (strong, nonatomic) NSDictionary *small_images;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *tk_rate;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *user_type;
@property (strong, nonatomic) NSString *volume;
@property (strong, nonatomic) NSString *zk_final_price;
@property (strong, nonatomic) NSString *zk_final_price_wap;

-(NSString *)showImageStr;

@end
