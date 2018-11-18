//
//  PNPercentDrivenInteractiveTransition.m
//  Penn
//
//  Created by pinn on 2018/11/4.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNPercentDrivenInteractiveTransition.h"
#import "PNContainerTransitionContext.h"

@interface PNPercentDrivenInteractiveTransition ()


@end

@implementation PNPercentDrivenInteractiveTransition
{
    __weak PNContainerTransitionContext *_transitionContext;
}

- (void)startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = (PNContainerTransitionContext *)transitionContext;
    [_transitionContext activeInteractiveTransition];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete{
    percentComplete = fmaxf(fminf(percentComplete, 1), 0);
    [_transitionContext updateInteractiveTransition:percentComplete];
    
}

- (void)finishInteractiveTransition{
    [_transitionContext finishInteractiveTransition];
}

- (void)cancelInteractiveTransition{
    [_transitionContext cancelInteractiveTransition];
    
}

@end
