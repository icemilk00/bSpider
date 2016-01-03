//
//  BaseAPIManager.h
//  DoDemo
//
//  Created by hp on 15/7/14.
//  Copyright (c) 2015年 hp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseAPIManager;

#pragma mark - APIManager
@protocol APIManager <NSObject>

@required
-(NSString *)apiMethodName;

@end

#pragma mark - APIManagerDelegate
@protocol APIManagerDelegate <NSObject>

-(void)APIManagerDidSucess:(BaseAPIManager *)manager;
-(void)APIManagerDidFailed:(BaseAPIManager *)manager;

@end

#pragma mark - ReformerProtocol
@protocol ReformerProtocol <NSObject>

@required
-(id)manager:(BaseAPIManager *)manager reformData:(NSDictionary *)data;

@end

typedef NS_ENUM (NSUInteger, RTAPIManagerErrorType){
    RTAPIManagerErrorTypeSuccess = 1000,    //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    RTAPIManagerErrorTypeNoContent,         //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    RTAPIManagerErrorTypeParamsError,       //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    RTAPIManagerErrorTypeTimeout,           //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    RTAPIManagerErrorTypeNoNetWork          //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

#pragma mark - 基类APIManager
@interface BaseAPIManager : NSObject

@property (nonatomic, weak) id <APIManager> child;
@property (nonatomic, weak) id <APIManagerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *dataSourceDic;  //服务器返回的原始数据的字典
@property (nonatomic, strong) NSString *retCode;            //服务器返回的retCode码
@property (nonatomic, strong) NSError* requestError;       //请求失败的error

-(id)fetchDataWithReformer:(id <ReformerProtocol> )reformer;

@end

#pragma mark - 请求分类下短信的API
@interface SMSAPIManager : BaseAPIManager <APIManager>

-(void)getSmsWithCategoryId:(NSString *)categoryId andPageNum:(NSInteger)pageNum;

@end

#pragma mark - 请求分类的API
@interface SMSCategoryAPIManager : BaseAPIManager <APIManager>

-(void)getSmsCategory;

@end