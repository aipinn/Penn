//
//  PNChildViewController.m
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNChildViewController.h"
#import "PNContainerDelegate.h"

@interface PNChildViewController ()

@property (nonatomic, strong) PNContainerDelegate * containerDelegate;

@end

@implementation PNChildViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.themeColor;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 200, 200, 50);
    [btn setTitle:[NSString stringWithFormat:@"%@_dismiss",self.title] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    
    //手势驱动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:pan];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)pop:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture{
    
    CGPoint point = [gesture translationInView:self.view];
    NSLog(@"-----%f", point.x);
    CGFloat percent = ABS(point.x) / self.view.frame.size.width;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.containerDelegate.interactive = YES;
            break;
        case UIGestureRecognizerStateChanged:
            [self.containerDelegate.interactionTransOld updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            [self.containerDelegate.interactionTransOld finishInteractiveTransition];
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }
    
}

@end
