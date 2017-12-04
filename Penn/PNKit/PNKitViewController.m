//
//  PNKitViewController.m
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNKitViewController.h"
#import "PNButton.h"
#import "PNCrazyButton.h"
#import "Penn-Swift.h"

static NSString * const reuseCellId = @"PNKitCell";

@interface PNKitViewController ()

@property (nonatomic, strong) NSArray * clsNameArr;

@end

@implementation PNKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Kit";
    [self setupUI];
    
    

}
#pragma mark - TableView Delegate/DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
    
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
        sender.imageView.transform = CGAffineTransformRotate(t, M_PI);

        sender.imageView.alpha = 0;
        sender.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        sender.imageView.alpha = 1;
        sender.titleLabel.alpha = 1;
    }];
    
}

#pragma mark - CustomView

- (void)customCrazyBtn{
    
    PNCrazyButton * btn = [PNCrazyButton crazyButton];
    btn.backgroundColor = [UIColor grayColor];
    [btn crazyButtonImage:@"backRed" title:@"返回"];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(clickRedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    PNButton * button = [[PNButton alloc] init];
    [button buttonImage:@"bottomNav-forwardEngaged" title:nil];
    button.callBack = ^(UIButton *button) {

        
    };
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

#pragma mark - PrepareData

- (void)prepareData{
    
    self.dataSource = [NSMutableArray arrayWithArray:@[
                                                       @"PNKeyboardController"
                                                       ]];
}

#pragma mark - SetupUI

- (void)setupUI{
    [super setupUI];
    [self prepareData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellId];
}


@end
