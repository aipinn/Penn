//
//  PNTabBarViewController.m
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNTabBarController.h"
#import "PNTabBarControllerDelegate.h"
#import "PNViewControllers.h"

@interface PNTabBarController()

@property (nonatomic, strong) PNTabBarControllerDelegate *tabDelegate;

@end

@implementation PNTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor greenColor];
    self.tabBar.barStyle = UIBarStyleBlack;
    
    PNOneController *one = [PNOneController new];
    one.tabBarItem.title = @"one";
    one.tabBarItem.badgeValue = @"1";
    
    PNTwoController *two = [PNTwoController new];
    two.tabBarItem.title = @"two";
    two.tabBarItem.badgeValue = @"2";
    
    PNThreeController *three = [PNThreeController new];
    three.tabBarItem.title = @"three";
    three.tabBarItem.badgeValue = @"3";
    
    self.viewControllers = @[one, two, three];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    CGFloat transX = point.x;
    CGFloat percent = ABS(transX)/self.view.frame.size.width;
    CGPoint velocity = [pan velocityInView:self.view];
//    NSLog(@"vel: X:%f Y:%f", velocity.x, velocity.y);
//    NSLog(@"point: X:%f Y:%f",point.x, point.y);
//    NSLog(@"percent: %f", percent);
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.tabDelegate = (PNTabBarControllerDelegate *)self.delegate;
            self.tabDelegate.interactive = YES;
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
            [self.tabDelegate.interactionTrans updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateCancelled:
            [self.tabDelegate.interactionTrans cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            if (percent > 0.3 || ABS(velocity.x) > 300) {
                [self.tabDelegate.interactionTrans finishInteractiveTransition];
                self.tabDelegate.interactionTrans.completionSpeed = 1;
            }else{
                [self.tabDelegate.interactionTrans cancelInteractiveTransition];
                self.tabDelegate.interactionTrans.completionSpeed = 1;

            }
            self.tabDelegate.interactive = NO;
            break;
        default:
            break;
    }
}


@end
