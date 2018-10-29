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
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:pan];
}

- (void)handleTap:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    CGFloat transX = point.x;
    CGFloat percent = transX/self.view.width;
    CGPoint velocity = [pan velocityInView:self.view];
    NSLog(@"vel: X:%f Y:%f", velocity.x, velocity.y);
    NSLog(@"point: X:%f Y:%f",point.x, point.y);
    NSLog(@"percent: %f", percent);
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.tabDelegate = (PNTabBarControllerDelegate *)self.delegate;
            self.tabDelegate.interactive = YES;
            if(point.x < 0){
                if (self.selectedIndex < self.viewControllers.count) {
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
            if (ABS(velocity.x) > 200) {
                [self.tabDelegate.interactionTrans finishInteractiveTransition];
            }
            if (percent < 0.3) {
                [self.tabDelegate.interactionTrans cancelInteractiveTransition];
            }else{
                [self.tabDelegate.interactionTrans finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}


@end
