//
//  PNContainerViewController.m
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNContainerViewController.h"
#import "PNContainerTransitionContext.h"
#import "PNPercentDrivenInteractiveTransition.h"

static CGFloat const kButtonSlotWidth = 64;
static CGFloat const kButtonSlotHeight = 44;

//=============默认转场============
@interface PNPrivateAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@end

//=============自定义容器控制器=================
@interface PNContainerViewController ()

@property (nonatomic, copy, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) UIView *privateContainerView;
@property (nonatomic, strong) UIView *privateButtonsView;
@property (nonatomic, strong) PNContainerTransitionContext * transitionCtx;

@property (nonatomic, assign) BOOL shouldReserve;
@property (nonatomic, assign) NSInteger priorSelectedIdx;

@end

#pragma mark - 转场控制器实现
@implementation PNContainerViewController
{
    id<UIViewControllerAnimatedTransitioning> _animator;
    id<UIViewControllerInteractiveTransitioning>_interactiveTrans;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    NSParameterAssert(viewControllers.count > 0);
    self = [super init];
    if (self) {
        self.viewControllers = [viewControllers copy];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interactionEnd:) name:PNContainerTransitionContextInteractionDidEndNotification object:nil];
    }
    return self;
}
- (void)interactionEnd:(NSNotification *)notify{
    self.transitionCtx = nil;
}
/**
 You can override this method in order to create your views manually. If you choose to do so, assign the root view of your view hierarchy to the view property. The views you create should be unique instances and should not be shared with any other view controller object. Your custom implementation of this method should not call super.
 If you want to perform any additional initialization of your views, do so in the viewDidLoad method.
 */
- (void)loadView
{
    UIView *rootView = [[UIView alloc]init];
    rootView.backgroundColor = [UIColor redColor];
    rootView.opaque = YES;

    self.privateContainerView = [[UIView alloc]init];
    self.privateContainerView.backgroundColor = [UIColor blackColor];
    self.privateContainerView.opaque = YES;

    self.privateButtonsView = [[UIView alloc] init];
    self.privateButtonsView.backgroundColor = [UIColor clearColor];
    self.privateButtonsView.tintColor = [UIColor colorWithWhite:1 alpha:0.75];

    // If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to NO, and then provide a non ambiguous, nonconflicting set of constraints for the view.
    [self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.privateButtonsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootView addSubview:self.privateContainerView];
    [rootView addSubview:self.privateButtonsView];

    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.viewControllers.count * kButtonSlotWidth]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonSlotHeight]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:STATUS_BAR_HEIGHT]];

    [self _addChildViewControllerButtons];
    self.view = rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedViewController = self.selectedViewController ? : self.viewControllers[0];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSCParameterAssert(selectedViewController);
    [self _transitionToChildController:selectedViewController];
    _selectedViewController = selectedViewController;
    [self _updateButtonSelection];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.selectedViewController = self.viewControllers[selectedIndex];
    
}
- (void)restoreSelectedIndex{
    self.shouldReserve = YES;
    _selectedIndex = _priorSelectedIdx;
}
- (void)_addChildViewControllerButtons
{
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *_Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [childViewController.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn setImage:icon forState:UIControlStateNormal];
        UIImage *selectedIcon = [childViewController.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn setImage:selectedIcon forState:UIControlStateSelected];

        [btn setTitle:childViewController.title forState:UIControlStateNormal];

        btn.tag = idx;
        [btn addTarget:self action:@selector(_buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.privateButtonsView addSubview:btn];
        [btn setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeLeading multiplier:1 constant:(idx + 0.5f) * kButtonSlotWidth]];
        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }];
}

- (void)_transitionToChildController:(UIViewController *)toViewController
{
    UIViewController *fromViewController = self.childViewControllers.count > 0 ? self.childViewControllers[0] : nil;
    if (toViewController == fromViewController || !self.isViewLoaded) {
        return;
    }

    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:NO];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.privateContainerView.bounds;

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    //初始化时,只有一个控制器toVC
    if (!fromViewController) {
        [self.privateContainerView addSubview:toView];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    //切换控制器,添加动画
    NSUInteger fromIdx = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIdx = [self.viewControllers indexOfObject:toViewController];
    _selectedIndex = toIdx;
    
    if ([self.delegate respondsToSelector:
         @selector(containerController:animationControllerForTransitionFromViewController:toViewController:)]) {
        _animator = [self.delegate containerController:self animationControllerForTransitionFromViewController:fromViewController toViewController:toViewController];
    }
    
    if ([self.delegate respondsToSelector:
         @selector(containerController:interactionControllerForAnimationController:)]) {
        _interactiveTrans = [self.delegate containerController:self interactionControllerForAnimationController:_animator];
    }

    if (_interactiveTrans) {//jiaohu
        
        PNContainerTransitionContext *transitionCtx = [[PNContainerTransitionContext alloc]
                                                       initWithContainerVC:self
                                                        fromViewController:fromViewController
                                                          toViewController:toViewController
                                                                goingRight:fromIdx < toIdx];
        self.transitionCtx = transitionCtx;
        
        if (self.delegate) {
            _priorSelectedIdx = fromIdx;
            [transitionCtx startInteractiveTransitionWith:self.delegate];
        }else{
            [transitionCtx startNonInteractiveTransitionWith:self.delegate];
        }

    } else {
    
        PNPrivateAnimatedTransitioning *animator = [[PNPrivateAnimatedTransitioning alloc]init];

        PNContainerTransitionContext *transitionCtx = [[PNContainerTransitionContext alloc]
                                                       initWithContainerVC:self
                                                       fromViewController:fromViewController
                                                         toViewController:toViewController
                                                               goingRight:fromIdx < toIdx];
        self.transitionCtx = transitionCtx;

        transitionCtx.animated = YES;
        transitionCtx.interactive = NO;
        transitionCtx.completedBlock = ^(BOOL didComplete) {
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];
            if ([animator respondsToSelector:@selector(animationEnded:)]) {
                [animator animationEnded:didComplete];
            }
            self.privateButtonsView.userInteractionEnabled = YES;
        };
        self.privateButtonsView.userInteractionEnabled = NO;
        [animator animateTransition:transitionCtx];
        [self.privateContainerView addSubview:toView];
    }
}

- (void)_updateButtonSelection
{
    [self.privateButtonsView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *_Nonnull stop) {
        btn.selected = self.viewControllers[idx] == self.selectedViewController;
    }];
}

- (void)_buttonTaped:(UIButton *)sender
{
    UIViewController *selectedViewController = self.viewControllers[sender.tag];
    self.selectedViewController = selectedViewController;
}

@end

#pragma mark - 提供默认的转场实现
@implementation PNPrivateAnimatedTransitioning

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;

    //CGRect rectFrom = [transitionContext initialFrameForViewController:fromVC];
    CGRect rectTo = [transitionContext initialFrameForViewController:toVC];

    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    CGFloat translation;

    translation = transitionContext.containerView.frame.size.width;
    if (rectTo.origin.x < 0) {
        translation = -translation;
    }
    fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
    toViewTransform = CGAffineTransformMakeTranslation(translation, 0);

    toView.transform = toViewTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return .35f;
}

@end
