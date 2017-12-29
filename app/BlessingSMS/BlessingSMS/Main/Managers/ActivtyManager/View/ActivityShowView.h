//
//  ActivityShowView.h
//
//  Created by mac on 2017/12/29.
//

#import <UIKit/UIKit.h>

@interface ActivityShowView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *showLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *leftBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, strong) NSString *showStr;

-(void)show;
@end
