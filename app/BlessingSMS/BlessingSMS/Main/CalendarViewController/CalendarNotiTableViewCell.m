//
//  CalendarNotiTableViewCell.m
//  BlessingSMS
//
//  Created by hp on 16/2/25.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "CalendarNotiTableViewCell.h"
#import "CalendarNotiModel.h"

@implementation CalendarNotiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)configUIWithModel:(CalendarNotiModel *)model
{
    self.notiContentLabel.text = model.notiContent;
    self.notiStateLabel.text = model.notiTimeStr;
    
    if(model.isExpired)
    {
        self.notiContentLabel.textColor = [UIColor grayColor];
        self.notiStateLabel.textColor = [UIColor grayColor];
        self.notiStateLabel.text = @"已过期";
        self.notiImageView.image = [UIImage imageNamed:@"unhasClock"];
    }
    else
    {
        self.notiContentLabel.textColor = [UIColor blackColor];
        self.notiStateLabel.textColor = [UIColor blackColor];
        
        if (model.isNeedNoti) {
            self.notiImageView.image = [UIImage imageNamed:@"hasClock"];
        }
        else
        {
            self.notiImageView.image = [UIImage imageNamed:@"unhasClock"];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
