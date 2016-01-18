//
//  SmsSendCell.h
//  BlessingSMS
//
//  Created by hp on 16/1/7.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookModel : NSObject
-(id)initWithDic:(NSDictionary *)dic;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *firstCharacter;
@property (nonatomic, assign) BOOL isSelected;

@end


@interface SmsSendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *showPhoneLabel;

-(void)sendSelectedWithModel:(AddressBookModel *)model;
-(void)updateUIWithData:(AddressBookModel *)model;

@end
