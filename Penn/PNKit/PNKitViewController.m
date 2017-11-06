//
//  PNKitViewController.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKitViewController.h"
#import "PNButton.h"
#import "UIButton+Addition.h"
#import "PNButton+Addition.h"

@interface PNKitViewController ()

@end

@implementation PNKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    PNButton * button = [[PNButton alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH/4, 100)];
    button.contentMode = PNButtonContentModeTopImage;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"按下" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button];

    PNButton * button2 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 +2, 100, SCREEN_WIDTH/4, 100)];
    button2.contentMode = PNButtonContentModeBottomImage;
    button2.backgroundColor = [UIColor orangeColor];
    [button2 setTitle:@"按下" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    PNButton * button3 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 4, 100, SCREEN_WIDTH/4, 100)];
    button3.contentMode = PNButtonContentModeRightImage;
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"按下" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
