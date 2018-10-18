//
//  PNCustomTransController.m
//  Penn
//
//  Created by emoji on 2018/10/12.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNFromViewController.h"
#import "PNToViewController.h"
#import "PNAnimatedTransitioning.h"
#import "PNNavigationDelegate.h"
#import "PNTransitioningDelegate.h"
#import "PNTabBarController.h"

@interface PNFromViewController ()

@property (nonatomic, strong) PNNavigationDelegate * navDelegate;
@property (nonatomic, strong) PNTransitioningDelegate *transDelegate;

@end

@implementation PNFromViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navDelegate = [PNNavigationDelegate new];
        self.transDelegate = [PNTransitioningDelegate new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

#pragma mark - Action

- (IBAction)pushViewController:(id)sender {
    PNToViewController *toVC = [PNToViewController new];
    self.navigationController.delegate = self.navDelegate;
    [self.navigationController pushViewController:toVC animated:YES];
}

- (IBAction)presentViewController:(id)sender {
    PNToViewController *toVC = [PNToViewController new];
    toVC.transitioningDelegate = self.transDelegate;
    [self presentViewController:toVC animated:YES completion:nil];
}
- (IBAction)tabBar:(id)sender {
    PNTabBarController * tabVC = [[PNTabBarController alloc] init];
    [self presentViewController:tabVC animated:YES completion:nil];
}


@end
