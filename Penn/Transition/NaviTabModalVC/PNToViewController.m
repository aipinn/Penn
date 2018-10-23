//
//  PNToViewController.m
//  Penn
//
//  Created by emoji on 2018/10/12.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNToViewController.h"
#import "PNNavigationDelegate.h"
#import "PNTransitioningDelegate.h"

@interface PNToViewController ()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanGesture;
@property (nonatomic, strong) PNNavigationDelegate *naviDelegate;
@property (nonatomic, strong) PNPercentDrivenInteractiveTransition *interTrans;
@property (nonatomic, strong) PNTransitioningDelegate *transDelegate;

@end

@implementation PNToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleEdgePanGesture:)];
    self.edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.edgePanGesture];
    
    //双指向下滑动dismiss
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [pan setMinimumNumberOfTouches:2];
    [self.view addGestureRecognizer:pan];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 侧滑pop,模拟原生pop动画
 */
- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    CGFloat percent = ABS(point.x/self.view.frame.size.width);
    NSLog(@"point X:%f Y:%f", point.x, point.y);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.naviDelegate = (PNNavigationDelegate *)self.navigationController.delegate;
            self.naviDelegate.interactive = YES;
           
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            break;
        case UIGestureRecognizerStateChanged:
            
            [self.naviDelegate.interactionTrans updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            if(percent > 0.5 || velocity.x > 999){
                [self.naviDelegate.interactionTrans finishInteractiveTransition];
                self.naviDelegate.interactive = NO;
            }else{
                [self.naviDelegate.interactionTrans cancelInteractiveTransition];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            [self.naviDelegate.interactionTrans cancelInteractiveTransition];
            break;
        default:
            break;
    }
}

/**
 pan,向下滑dismiss
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture{
    
    CGPoint point = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    CGFloat percent = ABS(point.y/self.view.frame.size.height);
    NSLog(@"point X:%f Y:%f", point.x, point.y);
    NSLog(@"velocity X:%f velocity Y:%f", velocity.x, velocity.y);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.transDelegate =(PNTransitioningDelegate *)self.transitioningDelegate;
            self.transDelegate.interactive = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [self.transDelegate.interactionTrans updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            if(percent > 0.4 || velocity.y > 999){
                [self.transDelegate.interactionTrans finishInteractiveTransition];
                self.transDelegate.interactive = NO;
            }else{
                [self.transDelegate.interactionTrans cancelInteractiveTransition];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            [self.transDelegate.interactionTrans cancelInteractiveTransition];
            break;
            
        default:
            break;
    }
}

@end
