//
//  PNPercentDrivenInteractiveTransition.h
//  Penn
//
//  Created by pinn on 2018/11/4.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNPercentDrivenInteractiveTransition : NSObject<UIViewControllerInteractiveTransitioning>

@property(nonatomic, readonly) CGFloat completionSpeed;
@property(nonatomic, readonly) UIViewAnimationCurve completionCurve;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;


@end

NS_ASSUME_NONNULL_END
