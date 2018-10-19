//
//  PNContainerViewController.m
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNContainerViewController.h"

static CGFloat const kButtonSlotWidth = 64;
static CGFloat const kButtonSlotHeight = 44;

@interface PNContainerViewController ()

@property (nonatomic, copy, readwrite) NSArray *viewControllers;
@property (nonatomic, strong) UIView *privateContainerView;
@property (nonatomic, strong) UIView *privateButtonsView;

@end

@implementation PNContainerViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers{
    NSParameterAssert(viewControllers.count > 0);
    self = [super init];
    if (self) {
        self.viewControllers = [viewControllers copy];
    }
    return self;
}

- (void)loadView{
    UIView *rootView = [[UIView alloc]init];
    rootView.backgroundColor = [UIColor blackColor];
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

    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.viewControllers.count *kButtonSlotWidth]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonSlotHeight]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:STATUS_BAR_HEIGHT]];

    
    [self _addChildViewControllerButtons];
    self.view = rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedViewController = self.selectedViewController?:self.viewControllers[0];

}

- (void)setSelectedViewController:(UIViewController *)selectedViewController{
    NSCParameterAssert(selectedViewController);
    [self _transitionToChildController:selectedViewController];
    _selectedViewController = selectedViewController;
    [self _updateButtonSelection];
}

#pragma mark - Private Methods

- (void)_addChildViewControllerButtons{
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)_transitionToChildController:(UIViewController *)toViewController{
    
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
    [self.privateContainerView addSubview:toView];
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [toViewController didMoveToParentViewController:self];
}

- (void)_updateButtonSelection{
    [self.privateButtonsView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.selected = self.viewControllers[idx] == self.selectedViewController;
    }];
}

- (void)_buttonTaped:(UIButton *)sender{
    UIViewController *selectedViewController = self.viewControllers[sender.tag];
    self.selectedViewController = selectedViewController;
                                                
}

@end
