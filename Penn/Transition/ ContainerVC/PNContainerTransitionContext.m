//
//  PNContainerTransitionContext.m
//  Penn
//
//  Created by pinn on 2018/11/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNContainerTransitionContext.h"
#import "PNPercentDrivenInteractiveTransition.h"

NSNotificationName const PNContainerTransitionContextDidEndNotification = @"PNContainerTransitionContextDidEndNotification";
NSNotificationName const PNContainerTransitionContextInteractionDidEndNotification = @"PNContainerTransitionContextInteractionDidEndNotification";

@interface PNContainerTransitionContext ()

@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, strong) NSDictionary *privateViews;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign) CGRect disappearingFromRect;

@property (nonatomic, assign) CGRect disappearingToRect;

@property (nonatomic, assign) CGRect appearingFromRect;

@property (nonatomic, assign) CGRect appearingToRect;

@property (nonatomic, strong) UIViewController *privateFromVC;
@property (nonatomic, strong) UIViewController *privateToVC;
@property (nonatomic, strong) PNContainerViewController *privateContainerVC;


@end

@implementation PNContainerTransitionContext
{
    BOOL _isCancled;
    NSInteger _fromIndx;
    NSInteger _toIdx;
    CGFloat _transitionPercent;
    CFTimeInterval _transitionDuration;
    id<UIViewControllerAnimatedTransitioning> _animator;

}
- (instancetype)initWithContainerVC:(PNContainerViewController *)containerVC
                 fromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
                                goingRight:(BOOL)isRight
{
    self = [super init];
    if (self) {
        self.privateContainerVC = containerVC;
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey: fromViewController,
                                        UITransitionContextToViewControllerKey: toViewController
                                        };
        self.privateViews = @{
                              UITransitionContextFromViewKey: fromViewController.view,
                              UITransitionContextToViewKey: toViewController.view
                              };
        CGRect bounds = self.containerView.bounds;
        CGFloat width = bounds.size.width;
        CGFloat travelDistance = isRight ? -width : width;
        self.disappearingFromRect = self.appearingToRect = bounds;
        self.disappearingToRect = CGRectOffset(bounds, travelDistance, 0);
        self.appearingFromRect = CGRectOffset(bounds, -travelDistance, 0);
        
        self.privateToVC = toViewController;
        self.privateFromVC = fromViewController;
    }
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.disappearingFromRect;
    } else {
        return self.appearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.disappearingToRect;
    } else {
        return self.appearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key
{
    return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete
{
    if (didComplete) {
        [_privateToVC didMoveToParentViewController:_privateContainerVC];
        [_privateFromVC willMoveToParentViewController:nil];
        [_privateFromVC.view removeFromSuperview];
        [_privateFromVC removeFromParentViewController];
    }else{
        [_privateToVC didMoveToParentViewController:_privateContainerVC];
        [_privateToVC willMoveToParentViewController:nil];
        [_privateToVC.view removeFromSuperview];
        [_privateToVC removeFromParentViewController];
        [self transitionEnd];
    }
}

- (void)transitionEnd{
    if (_animator && [_animator respondsToSelector:@selector(animationEnded:)]) {
        [_animator animationEnded:!_isCancled];
    }
    if (_isCancled) {
        [_privateContainerVC restoreSelectedIndex];
        _isCancled = NO;
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PNContainerTransitionContextInteractionDidEndNotification object:self];
}

//暂时还不确定初始化h中self.privateViews是否正确的赋值
- (nullable __kindof UIView *)viewForKey:(nonnull UITransitionContextViewKey)key
{
    return self.privateViews[key];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    _transitionPercent = percentComplete;
    self.containerView.layer.timeOffset = (CFTimeInterval)percentComplete * _transitionDuration;
    
}

- (void)pauseInteractiveTransition
{
    
}

- (void)finishInteractiveTransition
{
    _interactive = NO;
    CFTimeInterval pausedTime = _containerView.layer.timeOffset;
    _containerView.layer.speed = 1.0;
    _containerView.layer.timeOffset = 0.0;
    _containerView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_containerView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _containerView.layer.beginTime = timeSincePause;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(finishChangeButtonAppear:)];
    [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    
    // beginTime可能被修改，转场结束后恢复为0 
    CFTimeInterval remaningTime = (CFTimeInterval)(1 - _transitionPercent) * _transitionDuration;
    [self performSelector:@selector(dosome) withObject:nil afterDelay:remaningTime];
    
}

- (void)cancelInteractiveTransition
{
    _isCancled = YES;
    _interactive = NO;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(reverseCurrentAnimation:)];
    [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:PNContainerTransitionContextInteractionDidEndNotification
//                                                        object:self];
}
- (BOOL)transitionWasCancelled{
    return _isCancled;
}

#pragma mark - Selector

- (void)reverseCurrentAnimation:(CADisplayLink *)displayLink{
    CFTimeInterval timeOff = _containerView.layer.timeOffset - displayLink.duration;
    if (timeOff > 0) {
        _containerView.layer.timeOffset = timeOff;
        _transitionPercent = (CGFloat)timeOff/_transitionDuration;
        
    }else{
        [displayLink invalidate];
        _containerView.layer.timeOffset = 0;
        _containerView.layer.speed = 1;
        
        UIView *fakeFromView = [_privateFromVC.view snapshotViewAfterScreenUpdates:NO];
        [_containerView addSubview:fakeFromView];
        [self performSelector:@selector(removeFakeFromView:) withObject:fakeFromView afterDelay:1/60];
    }
    
}
- (void)removeFakeFromView:(UIView *)fakeView{
    [fakeView removeFromSuperview];
}
- (void)finishChangeButtonAppear:(CADisplayLink *)displayLink{
    
}
- (void)dosome{
    _containerView.layer.beginTime = 0.0;
}

@synthesize targetTransform;

#pragma mark - Public methods

- (void)activeInteractiveTransition{
    self.interactive = YES;
    _isCancled = NO;
    [self.privateContainerVC addChildViewController:self.privateToVC];
    self.containerView.layer.speed = 0;
    [_animator animateTransition:self];
}

- (void)startInteractiveTransitionWith:(id<PNContainerControllerDelegate>)delegate{
    _animator = [delegate containerController:self.privateContainerVC
animationControllerForTransitionFromViewController:self.privateFromVC
                             toViewController:self.privateToVC];
    
    _transitionDuration = [_animator transitionDuration:self];
    
    PNPercentDrivenInteractiveTransition *interactionTrans = (PNPercentDrivenInteractiveTransition *)[delegate containerController:self.privateContainerVC interactionControllerForAnimationController:_animator];
    [interactionTrans startInteractiveTransition:self];
    
}

- (void)startNonInteractiveTransitionWith:(id<PNContainerControllerDelegate>)delegate{
    _animated = [delegate containerController:self.privateContainerVC animationControllerForTransitionFromViewController:self.privateFromVC toViewController:self.privateToVC];
    _transitionDuration = [_animator transitionDuration:self];
    _interactive = NO;
    _isCancled = NO;
    [_privateContainerVC addChildViewController:_privateToVC];
    [_animator animateTransition:self];
    
}

@end
