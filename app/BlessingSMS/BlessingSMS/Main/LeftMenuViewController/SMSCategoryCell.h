//
//  SMSCategoryCell.h
//  BlessingSMS
//
//  Created by hp on 16/1/3.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCategoryModel.h"

typedef NS_ENUM (NSUInteger, CategoryCellAccessShowType){
    CategoryCellAccessShowNomal = 0,
    CategoryCellAccessShowUp,
    CategoryCellAccessShowDown,
};


@interface SMSCategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessImageView;
@property (weak, nonatomic) IBOutlet UIImageView *accessUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *accessDownImageView;

-(void)updateWithModel:(SMSCategoryModel *)model andIsSubCategory:(BOOL)isSubCategory;
-(void)setAccessImageViewType:(CategoryCellAccessShowType)type;
@end
