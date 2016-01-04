//
//  SMSSendViewController.h
//  BlessingSMS
//
//  Created by hp on 16/1/4.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSInfoModel.h"
#import <MessageUI/MessageUI.h>

@interface SMSSendViewController : BaseViewController <MFMessageComposeViewControllerDelegate>

-(id)initWithSMSModel:(SMSInfoModel *)infoModel;

@end
