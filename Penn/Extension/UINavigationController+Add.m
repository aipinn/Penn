//
//  UINavigationController+Add.m
//  HomeEconomics
//
//  Created by emoji on 2018/12/6.
//  Copyright © 2018 guanjia. All rights reserved.
//

#import "UINavigationController+Add.h"

@implementation UIViewController (Add)

@end

@implementation UINavigationController (Add)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController *topVC = [self topViewController];
    if([topVC respondsToSelector:@selector(navigationBarShouldPopOnBackClicked)]) {
        shouldPop = [topVC navigationBarShouldPopOnBackClicked];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end
