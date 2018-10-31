//
//  PNTabBarDelegate.m
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNTabBarControllerDelegate.h"
#import "PNAnimatedTransitioning.h"

@implementation PNTabBarControllerDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interactive = NO;
        self.interactionTrans = [[UIPercentDrivenInteractiveTransition alloc]init];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    NSUInteger fromIdx = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toIdx = [tabBarController.viewControllers indexOfObject:toVC];
    
    PNAnimatedTransitioning *atVC = [PNAnimatedTransitioning new];
    if (fromIdx < toIdx) {
        atVC.operationType = PNTransitionOperationTypeLeft;
    }else if (fromIdx > toIdx){
        atVC.operationType = PNTransitionOperationTypeRight;
    }else{
        
    }
    
    return atVC;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return _interactive ? _interactionTrans : nil;
}

@end
