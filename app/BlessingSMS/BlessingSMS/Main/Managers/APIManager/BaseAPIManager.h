//
//  BaseAPIManager.h
//  DoDemo
//
//  Created by hp on 15/7/14.
//  Copyright (c) 2015年 hp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseAPIManager;

#pragma mark -- APIManager --
@protocol APIManager <NSObject>

@required
-(NSString *)apiMethodName;

@end

#pragma mark -- APIManagerDelegate --
@protocol APIManagerDelegate <NSObject>

-(void)APIManagerDidSucess:(BaseAPIManager *)manager;
-(void)APIManagerDidFailed:(BaseAPIManager *)manager;

@end

#pragma mark -- 基类APIManager --
@interface BaseAPIManager : NSObject

@property (nonatomic, weak) id <APIManager> child;
@property (nonatomic, weak) id <APIManagerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *dataSourceDic;  //服务器返回的原始数据的字典
@property (nonatomic, strong) NSString *retCode;            //服务器返回的retCode码
@property (nonatomic, strong) NSError* requestError;       //请求失败的error

@end

#pragma mark -- 请求日韩男歌手的API --
@interface RiHanMaleSingersListAPIManager : BaseAPIManager <APIManager>

-(void)getDataWithCategoryId:(NSString *)categoryId andLastUpdateTime:(NSString *)lastUpdateTime;

@end