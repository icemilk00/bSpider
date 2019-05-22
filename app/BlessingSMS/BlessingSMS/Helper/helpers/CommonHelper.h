//
//  CommonHelper.h
//  BlessingSMS
//
//  Created by hp on 2019/5/14.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonHelper : NSObject

+(NSString *)addHttpsForUrlStr:(NSString *)urlStr;
+(NSString *)addHttpForUrlStr:(NSString *)urlStr;
@end

NS_ASSUME_NONNULL_END
