//
//  SMSWebViewController.h
//  BlessingSMS
//
//  Created by hp on 2019/10/10.
//  Copyright © 2019 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSWebViewController : BaseViewController 
- (instancetype)initWithUrlString:(NSString *)urlString;
@property (nonatomic)UIWebView* webView;
@end

NS_ASSUME_NONNULL_END
