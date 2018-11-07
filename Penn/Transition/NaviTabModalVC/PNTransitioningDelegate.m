//
//  PNTransitioningDelegate.m
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNTransitioningDelegate.h"
#import "PNAnimatedTransitioning.h"

@implementation PNTransitioningDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interactionTrans = [[UIPercentDrivenInteractiveTransition alloc]init];
        self.interactive = NO;
    }
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    PNAnimatedTransitioning *atVC = [PNAnimatedTransitioning new];
    atVC.operationType = PNTransitionOperationTypePresent;
    return atVC;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    PNAnimatedTransitioning *atVC = [PNAnimatedTransitioning new];
    atVC.operationType = PNTransitionOperationTypeDismiss;
    return atVC;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    PNPercentDrivenInteractiveTransition *interTrans = [PNPercentDrivenInteractiveTransition new];
//    return interTrans;
    return _interactive ? _interactionTrans : nil;
//    return _interactionTrans;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    PNPercentDrivenInteractiveTransition *interTrans = [PNPercentDrivenInteractiveTransition new];
//    return nil;
    return nil;
}


@end

/*
@implementation PNPercentDrivenInteractiveTransition

- (instancetype)initWithViewController:(UIViewController *)VC{
    self = [super init];
    if (self) {
        self.viewController = VC;
    }
    return self;
}

- (void)handleGesture:(UISwipeGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:self.viewController.view];
    
    CGFloat percent = point.y/self.viewController.view.frame.size.height;
    
    NSLog(@"%f", percent);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            [self finishInteractiveTransition];
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            break;
            
        default:
            break;
    }
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    
}

//@end
*/
