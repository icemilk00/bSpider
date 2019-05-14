//
//  MaterialInfoCell.m
//  BlessingSMS
//
//  Created by hp on 2019/5/14.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "MaterialInfoCell.h"

@implementation MaterialInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.juanLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.juanLabel.layer.borderWidth = 1;
}

-(void)setupWithModel:(MaterialDetailModel *)model {

    NSMutableAttributedString *fullTitle = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
    attchment.bounds = CGRectMake(0, -3, 15, 15);//设置frame
    if (model.user_type.integerValue == 1) {
        attchment.image = [UIImage imageNamed:@"天猫"];//设置图片
    } else {
        attchment.image = [UIImage imageNamed:@"淘宝"];//设置图片
    }
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    [fullTitle appendAttributedString:string];
    [fullTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [fullTitle appendAttributedString:[[NSAttributedString alloc] initWithString:model.title]];
    self.titleLabel.attributedText = fullTitle;
    
    self.juanLabel.text = [NSString stringWithFormat:@"%@元",[model coupon_amount]];
    //    self.juanLabel.text = [NSString stringWithFormat:@"%@元",[model juanPrice]];
    self.soldNumLabel.text = [NSString stringWithFormat:@"月售%@件",model.volume];
    
    NSMutableAttributedString *allStr = [[NSMutableAttributedString alloc] initWithString:@"卷后："];
    NSString *afterPrice = [NSString getSubStringWithStringA:model.zk_final_price stringB:[model coupon_amount]];
    afterPrice = [NSString interceptionPointString:afterPrice];
    NSAttributedString *price = [[NSAttributedString alloc] initWithString:afterPrice attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString *moneyUnit = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor redColor]}];
    [allStr appendAttributedString:moneyUnit];
    [allStr appendAttributedString:price];
    
    self.afterPriceLabel.attributedText = allStr;
    
    NSAttributedString *beforePrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：￥%@", [NSString interceptionPointString:model.zk_final_price]] attributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.beforePriceLabel.attributedText = beforePrice;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
