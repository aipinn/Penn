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
    
}



@end
