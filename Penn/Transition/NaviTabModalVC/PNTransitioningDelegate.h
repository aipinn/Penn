//
//  PNTransitioningDelegate.h
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionTrans;
@property (nonatomic, assign) BOOL interactive;


@end

//@interface PNPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
//
//- (void)handleGesture:(UIGestureRecognizer *)gesture;
//- (instancetype)initWithViewController:(UIViewController *)VC;
//@property (nonatomic, strong) UIViewController *viewController;
//
//@end

NS_ASSUME_NONNULL_END
