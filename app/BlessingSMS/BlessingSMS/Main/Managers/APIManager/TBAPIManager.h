//
//  TBAPIManager.h
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "BaseAPIManager.h"

@interface TBAPIManager : BaseAPIManager

@end


#pragma mark - 淘宝客API:(获取淘宝联盟选品库的宝贝信息)
@interface TB_FavoritesItemAPIManager : TBAPIManager <APIManager>

-(void)getTB_FavoritesItem:(NSString *)itemID andPageNum:(NSInteger)pageNum;

@end
