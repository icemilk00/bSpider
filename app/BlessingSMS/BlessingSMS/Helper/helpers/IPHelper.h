//
//  IPHelper.h
//  QYHTabbarController
//
//  Created by hp on 2019/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPHelper : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end

NS_ASSUME_NONNULL_END
