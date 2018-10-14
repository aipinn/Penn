//
//  PNCustomTransController.m
//  Penn
//
//  Created by emoji on 2018/10/12.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNCustomTransController.h"
#import "PNToViewController.h"


@interface PNCustomTransController ()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation PNCustomTransController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

//Required
//执行动画的地方
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
    [UIView animateWithDuration:3 animations:^{
        fromView.transform = fromTransform;
        toView.transform = toTransform;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        //保持最后的状态
        [transitionContext completeTransition:YES];
    }];
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 3.0f;
}
//Optional 动画结束调用
- (void)animationEnded:(BOOL)transitionCompleted{

}

#pragma mark - Action

- (IBAction)nextController:(id)sender {
    PNToViewController *toVC = [PNToViewController new];
    toVC.transitioningDelegate = self;
//    [self.navigationController pushViewController:toVC animated:YES];
    [self.navigationController presentViewController:toVC animated:YES completion:nil];
}


@end
