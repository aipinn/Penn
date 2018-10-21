//
//  PNContainerDelegate.m
//  Penn
//
//  Created by pinn on 2018/10/21.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNContainerDelegate.h"
#import "PNAnimatedTransitioning.h"

@implementation PNContainerDelegate

- (nonnull id<UIViewControllerAnimatedTransitioning>)containerController:(nonnull PNContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(nonnull UIViewController *)fromVC toViewController:(nonnull UIViewController *)toVC {
    PNAnimatedTransitioning *atd = [PNAnimatedTransitioning new];
    NSUInteger fromIdx = [containerViewController.viewControllers indexOfObject:fromVC];
    NSUInteger toIdx = [containerViewController.viewControllers indexOfObject:toVC];
    atd.operationType = fromIdx > toIdx ? PNTransitionOperationTypeContainerRight : PNTransitionOperationTypeContainerLeft;

    return atd;
}

//- (nonnull id<UIViewControllerInteractiveTransitioning>)containerController:(nonnull PNContainerViewController *)containerViewController interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController {
//
//}

@end
