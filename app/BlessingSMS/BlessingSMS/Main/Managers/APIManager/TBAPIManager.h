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

#pragma mark - 淘宝客API:(获取淘宝联盟选品库列表信息)
@interface TB_FavoritesListAPIManager : TBAPIManager <APIManager>

-(void)getTB_FavoritesList;

@end

#pragma mark - 好卷清单API:(获取淘宝客优惠券)
@interface TB_JuanListAPIManager : TBAPIManager <APIManager>

-(void)getTB_JuanListWithCat:(NSString *)cat searchStr:(NSString *)q andPageNum:(NSInteger)pageNum;

@end

#pragma mark - 宝贝详情API:(获取宝贝详情)
@interface TB_ItemDetailAPIManager : TBAPIManager <APIManager>

-(void)getTB_ItemDetailWithId:(NSString *)itemId;

@end

#pragma mark - 通用物料API:(通用物料)
@interface TB_MaterialAPIManager : TBAPIManager <APIManager>

-(void)getTB_MaterialWithId:(NSString *)material_id andPageNum:(NSInteger)pageNum;

@end

#pragma mark - 关联推荐API:()
@interface TB_ItemRecommendAPIManager : TBAPIManager <APIManager>

-(void)getTB_MaterialWithId:(NSString *)itemId;

@end

#pragma mark - h5详情API:()
@interface TB_ItemH5DetailAPIManager : TBAPIManager <APIManager>

-(void)getTB_ItemDetailWithId:(NSString *)itemId;

@end

#pragma mark - 通用物料搜索API:()
@interface TB_SearchMaterialAPIManager : TBAPIManager <APIManager>
//通用搜索
-(void)getTB_SearchMaterialWithPageNum:(NSInteger)pageNum cat:(NSString *)cat searchStr:(NSString *)searchStr complete:(APIManagerComplete)complete;

@end

#pragma mark - 猜你喜欢API:()
@interface TB_GuessLikeAPIManager : TBAPIManager <APIManager>

-(void)getTB_GuessLikeWithPageNum:(NSInteger)pageNum complete:(APIManagerComplete)complete;

@end

#pragma mark - 淘口令生成API:()
@interface TB_TKLCreateAPIManager : TBAPIManager <APIManager>

-(void)getTB_TKLCreateWithTtitle:(NSString *)title url:(NSString *)url logo:(NSString *)logo complete:(APIManagerComplete)complete;
@end
