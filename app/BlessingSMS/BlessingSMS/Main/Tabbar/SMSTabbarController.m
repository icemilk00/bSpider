//
//  SMSTabbarController.m
//  Pods-SMSTabbarController
//
//  Created by HP on 2019/3/4.
//

#import "SMSTabbarController.h"

@interface SMSTabbarController ()

@end

@implementation SMSTabbarController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    UIImage *image = [self imageWithRect:rect color:[UIColor clearColor]];
    [self.tabBar setBackgroundImage:image]; //去掉顶部线条，先设成透明背景
    [self.tabBar setShadowImage:image];
    [self.tabBar setBackgroundImage:[self imageWithRect:rect color:UIColorFromHex(0xffffff)]];
//    [self.tabBar setTintColor:JFThemeMainColor];
    [self.tabBar setTranslucent:NO];
    self.delegate = self;
  
//    [self addChildVc:[UIViewController new] title:@"信用钱包" image:@"index_qianbao_icon" selectedImage:@"index_qianbao_down_icon"];
//    [self addChildVc:[UIViewController new] title:@"信用付" image:@"index_xinyongfu_icon" selectedImage:@"index_xinyongfu_down_icon"];
//    [self addChildVc:[UIViewController new] title:@"我的" image:@"index_my_icon" selectedImage:@"index_my_down_icon"];
    
}

- (UIImage *)imageWithRect:(CGRect)rect color:(UIColor *)color {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    if (!childVc) {
        childVc = [[UIViewController alloc] init];
    }
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
//    nav.navigationBar.translucent = NO;
    // 添加为子控制器
    [self addChildViewController:childVc];
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"select tab index [%@]",@(self.selectedIndex));
//    NSInteger selectIndex = [self.viewControllers indexOfObject:viewController];

    return YES;
}


@end
