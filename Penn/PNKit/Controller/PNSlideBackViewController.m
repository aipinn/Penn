//
//  PNSlideBackViewController.m
//  Penn
//
//  Created by emoji on 2018/10/22.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNSlideBackViewController.h"

@interface PNSlideBackViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PNSlideBackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self _customBackItem];
    [self.view addSubview:self.scrollView];
    
}

/**
 自定义leftBarButtonItem后侧滑返回会失效
 */
- (void)_customBackItem{
    //将代理设置为nil,即便自定义也可以侧滑返回
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    UIButton * btn = [UIButton new];
    btn.title = @"BACK";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = item;

}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor cyanColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollView;
}

- (void)customNavigationView{
    
}

@end
