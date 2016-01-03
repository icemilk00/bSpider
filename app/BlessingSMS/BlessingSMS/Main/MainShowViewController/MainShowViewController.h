//
//  MainShowViewController.h
//  BlessingSMS
//
//  Created by hp on 15/12/30.
//  Copyright © 2015年 hxp. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseAPIManager.h"

@interface MainShowViewController : BaseViewController <APIManagerDelegate, UITableViewDelegate, UITableViewDataSource>

-(void)loadDataWithCategoryId:(NSString *)requestCategoryId;

@end
