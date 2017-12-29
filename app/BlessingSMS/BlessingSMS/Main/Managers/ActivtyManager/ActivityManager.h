//
//  ActivityManager.h
//
//
//  Created by mac on 2017/12/29.
//

#import <Foundation/Foundation.h>

static NSString * ActivityUpdateNotifi = @"ActivityUpdateNotifi";

@interface ActivityManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *showStr;

-(void)showAlert;
@end
