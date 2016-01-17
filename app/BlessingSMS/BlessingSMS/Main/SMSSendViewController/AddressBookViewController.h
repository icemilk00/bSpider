//
//  AddressBookViewController.h
//  BlessingSMS
//
//  Created by hp on 16/1/7.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
@interface AddressBookViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>
-(id)initWithSmsInfo:(SMSInfoModel *)smsInfoModel;
@end
