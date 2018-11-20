//
//  PNContainerTransitionContext.h
//  Penn
//
//  Created by pinn on 2018/11/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSNotificationName const PNContainerTransitionContextInteractionDidEndNotification;

@interface PNContainerTransitionContext : NSObject<UIViewControllerContextTransitioning>

@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@property (nonatomic, copy) void (^ completedBlock)(BOOL didComplete);

- (instancetype)initWithContainerVC:(PNContainerViewController *)containerVC
                 fromViewController:(UIViewController *)fromViewController
                   toViewController:(UIViewController *)toViewController
                         goingRight:(BOOL)isRight;

- (void)activeInteractiveTransition;
- (void)startInteractiveTransitionWith:(id<PNContainerControllerDelegate>)delegate animator:(id<UIViewControllerAnimatedTransitioning>)animator;
- (void)startNonInteractiveTransitionWith:(id<PNContainerControllerDelegate>)delegate animator:(id<UIViewControllerAnimatedTransitioning>)animator;

@end


NS_ASSUME_NONNULL_END
