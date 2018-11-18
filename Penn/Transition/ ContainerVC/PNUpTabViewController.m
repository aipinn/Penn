//
//  PNUpTabViewController.m
//  Penn
//
//  Created by pinn on 2018/11/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNUpTabViewController.h"
#import "PNContainerDelegate.h"

@interface PNUpTabViewController ()

@property (nonatomic, weak) PNContainerDelegate *containerDelegate;


@end

@implementation PNUpTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //手势驱动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture{

    CGPoint velocity = [gesture velocityInView:self.view];
    
    CGPoint point = [gesture translationInView:self.view];
    CGFloat percent = ABS(point.x) / self.view.frame.size.width;
    self.containerDelegate = (PNContainerDelegate *)self.delegate;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.containerDelegate.interactive = YES;
            if(velocity.x < 0){
                if (self.selectedIndex < self.viewControllers.count-1) {
                    self.selectedIndex += 1;
                }
            }else{
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self.containerDelegate.interactionTrans updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            self.containerDelegate.interactive = NO;
            if (percent < 0.5) {
                [self.containerDelegate.interactionTrans cancelInteractiveTransition];
            }else{
                [self.containerDelegate.interactionTrans finishInteractiveTransition];
            }
            break;
            default:
            break;
    }
    
}


@end
