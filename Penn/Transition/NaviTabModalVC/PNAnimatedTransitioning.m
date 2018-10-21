//
//  PNAnimatedTransitioningDelegete.m
//  Penn
//
//  Created by emoji on 2018/10/15.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNAnimatedTransitioning.h"



@implementation PNAnimatedTransitioning


- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    CGFloat translation;
    
    switch (_operationType) {
        case PNTransitionOperationTypePush:
            translation = containerView.frame.size.width;
            fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
            toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
            break;
        case PNTransitionOperationTypePop:
            translation = containerView.frame.size.width;
            fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
            toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
            break;
        case PNTransitionOperationTypePresent:
            translation = containerView.frame.size.height;
            fromViewTransform = CGAffineTransformMakeTranslation(0, -translation);
            toViewTransform = CGAffineTransformMakeTranslation(0, translation);
            break;
        case PNTransitionOperationTypeDismiss:
            translation = containerView.frame.size.height;
            fromViewTransform = CGAffineTransformMakeTranslation(0, translation);
            toViewTransform = CGAffineTransformMakeTranslation(0, -translation);
            break;
        case PNTransitionOperationTypeLeft:
            translation = containerView.frame.size.width;
            fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
            toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
            break;
        case PNTransitionOperationTypeRight:
            translation = containerView.frame.size.width;
            fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
            toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
            break;
        case PNTransitionOperationTypeContainerLeft:
            
            break;
        case PNTransitionOperationTypeContainerRight:
            
            break;
        default:
            break;
    }

    switch (_operationType) {
        case PNTransitionOperationTypePresent:
            [containerView addSubview:toView];
            break;
        case PNTransitionOperationTypeDismiss:
            break;
        default:[containerView addSubview:toView];
            break;
    }
    
    
    toView.transform = toViewTransform;
    if (self.operationType == PNTransitionOperationTypeContainerRight || self.operationType == PNTransitionOperationTypeContainerLeft) {
        toVC.view.alpha = 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            fromVC.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }else{
        [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
            fromView.transform = fromViewTransform;
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            fromView.transform = CGAffineTransformIdentity;
            toView.transform = CGAffineTransformIdentity;
            //保持最后的状态
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animationEnded:(BOOL)transitionCompleted{
    
}

@end
