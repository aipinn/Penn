//
//  PNContainerViewController.h
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PNContainerControllerDelegate;
@interface PNContainerViewController : UIViewController

@property (nonatomic, copy, readonly) NSArray *viewControllers;

@property (nonatomic, strong) UIViewController *selectedViewController;

@property (nonatomic, weak) id<PNContainerControllerDelegate>delegate;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end

@protocol PNContainerControllerDelegate <NSObject>
@optional
- (id<UIViewControllerAnimatedTransitioning>)containerController:(PNContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

- (id<UIViewControllerInteractiveTransitioning>)containerController:(PNContainerViewController *)containerViewController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController;

@end
NS_ASSUME_NONNULL_END
