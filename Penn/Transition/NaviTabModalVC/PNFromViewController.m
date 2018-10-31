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
#import "PNTabBarControllerDelegate.h"
#import "PNContainerViewController.h"
#import "PNChildViewController.h"
#import "PNContainerDelegate.h"

@interface PNFromViewController ()

@property (nonatomic, strong) PNNavigationDelegate * navDelegate;
@property (nonatomic, strong) PNTransitioningDelegate *transDelegate;
@property (nonatomic, strong) PNTabBarControllerDelegate *tabDelegate;
@property (nonatomic, strong) PNContainerDelegate *containerDelegate;


@end

@implementation PNFromViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navDelegate = [PNNavigationDelegate new];
        self.transDelegate = [PNTransitioningDelegate new];
        self.tabDelegate = [PNTabBarControllerDelegate new];
        self.containerDelegate = [PNContainerDelegate new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    toVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:toVC animated:YES completion:nil];
}
- (IBAction)tabBar:(id)sender {
    PNTabBarController * tabVC = [[PNTabBarController alloc] init];
    tabVC.delegate = self.tabDelegate;
    [self presentViewController:tabVC animated:YES completion:nil];
}
- (IBAction)container:(id)sender {
    PNContainerViewController *containerViewController = [[PNContainerViewController alloc] initWithViewControllers:[self _configChildViewControllers]];
    //使用自定义代理实现转场
//    containerViewController.delegate = self.containerDelegate;
    [self presentViewController:containerViewController animated:YES completion:nil];
}

- (NSArray *)_configChildViewControllers{
    
    
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *configurations = @[
                                @{@"title": @"First", @"color": [UIColor colorWithRed:0.4f green:0.8f blue:1 alpha:1]},
                                @{@"title": @"Second", @"color": [UIColor colorWithRed:1 green:0.4f blue:0.8f alpha:1]},
                                @{@"title": @"Third", @"color": [UIColor colorWithRed:1 green:0.8f blue:0.4f alpha:1]},
                                ];
    
    for (NSDictionary *configuration in configurations) {
        PNChildViewController *childViewController = [[PNChildViewController alloc] init];
        
        childViewController.title = configuration[@"title"];
        childViewController.themeColor = configuration[@"color"];
//        childViewController.tabBarItem.image = [UIImage imageNamed:configuration[@"title"]];
//        childViewController.tabBarItem.selectedImage = [UIImage imageNamed:[configuration[@"title"] stringByAppendingString:@" Selected"]];
        
        [childViewControllers addObject:childViewController];
    }
    
    return childViewControllers;
}

@end
