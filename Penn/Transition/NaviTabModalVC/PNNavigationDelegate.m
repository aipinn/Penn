//
//  PNNavigationDelegate.m
//  Penn
//
//  Created by emoji on 2018/10/15.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNNavigationDelegate.h"
#import "PNAnimatedTransitioning.h"

@implementation PNNavigationDelegate
{
    BOOL _interactive;
    UIPercentDrivenInteractiveTransition *_interactionController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interactive = NO;
        _interactive = [[UIPercentDrivenInteractiveTransition alloc]init];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    PNAnimatedTransitioning *atVC = [PNAnimatedTransitioning new];
    if (operation == UINavigationControllerOperationPop) {
        atVC.operationType = PNTransitionOperationTypePop;
    }else if (operation == UINavigationControllerOperationPush){
        atVC.operationType = PNTransitionOperationTypePush;
    }
    return atVC;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return _interactive ? _interactionController : nil;
}
@end
