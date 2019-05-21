//
//  HaoWuThemeView.m
//  BlessingSMS
//
//  Created by hp on 2019/5/21.
//  Copyright © 2019 hxp. All rights reserved.
//

#import "HaoWuThemeView.h"
#import "HaoWuThemeViewController.h"

#define BASE_TAG  1000

@interface HaoWuThemeView ()

@property (strong, nonatomic) NSArray *themeArray;

@end

@implementation HaoWuThemeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.themeArray = @[@{@"name":@"大额卷",
                              @"imageName":@"大额优惠券",
                              @"material_id":@"9660"},
                            @{@"name":@"好物居",
                              @"imageName":@"好物居",
                              @"material_id":@"13366"},
                            @{@"name":@"品牌尖货",
                              @"imageName":@"品牌",
                              @"material_id":@"3786"},
                            @{@"name":@"有好货",
                              @"imageName":@"购物车",
                              @"material_id":@"4092"},
                            @{@"name":@"潮流范",
                              @"imageName":@"潮流",
                              @"material_id":@"4093"},
                            @{@"name":@"特惠",
                              @"imageName":@"特惠",
                              @"material_id":@"4094"}];
        [self setupTheme];
    }
    return self;
    
}

-(void)setupTheme {

    for (int i = 0; i < self.themeArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        btn.center = CGPointMake(i%3 * (SCREEN_WIDTH/3.0f) + (SCREEN_WIDTH/6.0f), i/3 * (self.frame.size.height/2.0f) + (self.frame.size.height/4.0f));
        btn.layer.cornerRadius = btn.frame.size.width/2.0f;
        [btn setImage:[UIImage imageNamed:self.themeArray[i][@"imageName"]] forState:UIControlStateNormal];
        btn.tag = BASE_TAG + i;
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.center.x - 30, btn.frame.origin.y + btn.frame.size.height + 8, 60, 13)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = self.themeArray[i][@"name"];
        [self addSubview:label];
    }
    
}

-(void)btnAction:(UIButton *)btn {
    
    NSInteger index = btn.tag - BASE_TAG;
    NSString *material_id = self.themeArray[index][@"material_id"];
    
    HaoWuThemeViewController *themeVc = [[HaoWuThemeViewController alloc] init];
    themeVc.materialId = material_id;
    themeVc.title = self.themeArray[index][@"name"];
    [self.viewController.navigationController pushViewController:themeVc animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
