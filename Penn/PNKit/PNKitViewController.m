//
//  PNKitViewController.m
//  Penn
//
//  Created by PENN on 2017/11/4.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNKitViewController.h"
#import "PNButton.h"
#import "PNCrazyButton.h"
#import "Penn-Swift.h"
#import "PNViewButton.h"
#import "PNEmptyButton.h"

@interface PNKitViewController ()


@end

@implementation PNKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customCrazyBtn];
    [self customButton];

    NSMutableDictionary * dict = [NSMutableDictionary new];
    NSString * str = nil;
    [dict setObject:str forKey:@"key"];

}

#pragma mark - Action

- (void)clickRedBtn:(PNCrazyButton *)sender{
    NSLog(@"红色按钮被点击了");
    //UIView 动画就近原则, 无法旋转2π
    //1. CGAffineTransformRotate代表每次旋转是以上次旋转之后的中心进行旋转
    //2. CGAffineTransformMakeRotation只能旋转一次, 与当t=CGAffineTransformIdentity效果相同
    [UIView animateWithDuration:0.5 animations:^{
        
        CGAffineTransform t = sender.imageView.transform;
        //1. sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        //2.
        sender.imageView.transform = CGAffineTransformRotate(t, M_PI);

        sender.imageView.alpha = 0;
        sender.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        sender.imageView.alpha = 1;
        sender.titleLabel.alpha = 1;
    }];
    
}

- (void)clickviewbtn:(UIControl *)sender{
    NSLog(@"viewBtn clicked");
}
- (void)clickemptyBtn:(UIControl *)sender{
    NSLog(@"emptyBtn clicked");
}
#pragma mark - CustomView

- (void)customCrazyBtn{

    //1. Empty xib中手动添加view 可以使用frame控制控件位置大小
    PNEmptyButton * emptyBtn = [PNEmptyButton emptyButton];
    emptyBtn.frame = CGRectMake(SCREEN_WIDTH-150, 88, 150, 50);
    //    [emptyBtn addTarget:self action:@selector(clickemptyBtn:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * etap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickemptyBtn:)];
    [emptyBtn addGestureRecognizer:etap];
    [self.view addSubview:emptyBtn];
    // 或者使用约束
    //        [emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.center.equalTo(self.view);
    //            make.size.mas_equalTo(CGSizeMake(200, 50));
    //        }];
    
    //2. View xib默认的xib不能使用frame控制控件的位置大小
    PNViewButton * viewbtn = [PNViewButton viewButton];
    //    viewbtn.frame = CGRectMake(0, 200, 100, 50);
    UITapGestureRecognizer * vtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickviewbtn:)];
    [viewbtn addGestureRecognizer:vtap];
    //    [viewbtn addTarget:self action:@selector(clickviewbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewbtn];
    [viewbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    //3. Empty 使用示例
    PNCrazyButton * btn = [PNCrazyButton crazyButton];
    btn.frame = CGRectMake(0, 100, 60, 80);
    btn.backgroundColor = [UIColor grayColor];
    btn.imageView.image = [UIImage imageNamed:@"backRed"];
    btn.titleLabel.text = @"返回";
    [btn addTarget:self action:@selector(clickRedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)customButton{
    PNButton * button = [[PNButton alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH/4, 100)];
    button.pn_contentMode = PNButtonContentModeTopImage;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"按下" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    PNButton * button2 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 +2, 100, SCREEN_WIDTH/4, 100)];
    button2.pn_contentMode = PNButtonContentModeBottomImage;
    button2.backgroundColor = [UIColor orangeColor];
    [button2 setTitle:@"按下" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    PNButton * button3 = [[PNButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 4, 100, SCREEN_WIDTH/4, 100)];
    button3.pn_contentMode = PNButtonContentModeRightImage;
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"按下" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
    [self.view addSubview:button3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
