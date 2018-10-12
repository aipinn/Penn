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
    
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}
//Optional 动画结束调用
- (void)animationEnded:(BOOL)transitionCompleted{

}

#pragma mark - Action

- (IBAction)nextController:(id)sender {
    PNToViewController *toVC = [PNToViewController new];
    toVC.transitioningDelegate = self;
    [self.navigationController pushViewController:toVC animated:YES];
}


@end
