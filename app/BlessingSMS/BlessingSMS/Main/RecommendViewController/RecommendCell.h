//
//  RecommendCell.h
//  BlessingSMS
//
//  Created by hp on 2017/5/22.
//  Copyright © 2017年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendInfoModel.h"

@interface RecommendCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;


-(void)setupWithModel:(RecommendInfoModel *)model;

@end
