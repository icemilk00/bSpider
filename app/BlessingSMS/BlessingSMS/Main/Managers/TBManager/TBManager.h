//
//  TBManager.h
//  BlessingSMS
//
//  Created by hp on 2017/5/23.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBManager : NSObject <APIManagerDelegate>

+(TBManager *)sharedInstance;

-(void)initConfig;
-(void)initTBFavList;

-(NSString *)favIDForCategoryID:(NSString *)categoryID;

-(void)showPageWithUrl:(NSString *)clickUrl;
@end
