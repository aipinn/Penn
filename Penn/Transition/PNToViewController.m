//
//  PNToViewController.m
//  Penn
//
//  Created by emoji on 2018/10/12.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNToViewController.h"

@interface PNToViewController ()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanGesture;

@end

@implementation PNToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleEdgePanGesture:)];
    self.edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.edgePanGesture];
    
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
}

@end
