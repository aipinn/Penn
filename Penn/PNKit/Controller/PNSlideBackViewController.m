//
//  PNSlideBackViewController.m
//  Penn
//
//  Created by emoji on 2018/10/22.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNSlideBackViewController.h"

@interface PNSlideBackViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *aView;

@end

@implementation PNSlideBackViewController
{
    CGFloat _offset;
}
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
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    aView.backgroundColor = [UIColor orangeColor];
    self.aView = aView;
    [self.scrollView addSubview:aView];
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
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)customNavigationView{
    
}

#pragma mark - UIScrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat diff = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    diff = offsetY - _offset;
    _offset = offsetY;
    
    NSLog(@"offsetY:%f/tdiff:%f",offsetY, diff);
    
    CGAffineTransform transform = self.aView.transform;
    self.aView.transform = CGAffineTransformTranslate(transform, 0, diff);
}

@end
