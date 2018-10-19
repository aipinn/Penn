//
//  PNViewControllers.m
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNViewControllers.h"

@implementation PNViewControllers

@end

@implementation PNOneController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"pop"];
    btn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pop:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation PNTwoController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    
}
@end

@implementation PNThreeController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}
@end
