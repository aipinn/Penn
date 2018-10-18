//
//  PNCustomTransController.m
//  Penn
//
//  Created by emoji on 2018/10/12.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNCustomTransController.h"
#import "PNToViewController.h"
#import "PNAnimatedTransitioningDelegete.h"
#import "PNNavigationDelegate.h"

@interface PNCustomTransController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) PNNavigationDelegate * navDelegate;


@end

@implementation PNCustomTransController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navDelegate = [PNNavigationDelegate new];
    self.navigationController.delegate = self.navDelegate;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PNAnimatedTransitioningDelegete new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PNAnimatedTransitioningDelegete new];
}

//Optional 动画结束调用
- (void)animationEnded:(BOOL)transitionCompleted{

}

#pragma mark - Action

- (IBAction)nextController:(id)sender {
    PNToViewController *toVC = [PNToViewController new];
    toVC.transitioningDelegate = self;
    [self.navigationController pushViewController:toVC animated:YES];
//    [self.navigationController presentViewController:toVC animated:YES completion:nil];
}


@end
