//
//  SmsCell.m
//  BlessingSMS
//
//  Created by hp on 16/1/1.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "SmsCell.h"

@implementation SmsCell

- (void)awakeFromNib {
    // Initialization code
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, self.frame.size.height);
    
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
