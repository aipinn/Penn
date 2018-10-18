//
//  PNAnimatedTransitioningDelegete.m
//  Penn
//
//  Created by emoji on 2018/10/15.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNAnimatedTransitioningDelegete.h"

@implementation PNAnimatedTransitioningDelegete

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform toTransform = CGAffineTransformIdentity;
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    translation = -translation;
    fromTransform = CGAffineTransformMakeTranslation(translation, 0);
    toTransform = CGAffineTransformMakeTranslation(-translation, 0);
    
    toView.transform = toTransform;
    [UIView animateWithDuration:1.0f animations:^{
        fromView.transform = fromTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        //保持最后的状态
        [transitionContext completeTransition:YES];
    }];
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

@end
