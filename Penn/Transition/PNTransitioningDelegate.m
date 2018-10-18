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

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    
//}
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    
//}


@end
