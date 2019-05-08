//
//  SMSTabbarController.h
//  Pods-SMSTabbarController
//
//  Created by HP on 2019/3/4.
//

#import <UIKit/UIKit.h>

@interface SMSTabbarController : UITabBarController<UITabBarControllerDelegate>
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;
@end
