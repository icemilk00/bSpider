//
//  CalendarNotiTableViewCell.h
//  BlessingSMS
//
//  Created by hp on 16/2/25.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarNotiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notiContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *notiStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notiImageView;

-(void)configUIWithModel:(CalendarNotiModel *)model;
@end
