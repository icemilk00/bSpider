//
//  RecommendViewController.h
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import "BaseViewController.h"

@interface RecommendViewController : BaseViewController <APIManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

-(id)initWithFavID:(NSString *)favID;

@end
