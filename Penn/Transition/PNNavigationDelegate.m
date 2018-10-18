//
//  PNNavigationDelegate.m
//  Penn
//
//  Created by emoji on 2018/10/15.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNNavigationDelegate.h"
#import "PNAnimatedTransitioningDelegete.h"

@implementation PNNavigationDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return [PNAnimatedTransitioningDelegete new];
}

@end
