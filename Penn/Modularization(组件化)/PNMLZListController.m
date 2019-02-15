//
//  PNMLZListController.m
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNMLZListController.h"

static NSMutableArray * titles;
static NSMutableDictionary * titleWithHandlers;

@interface PNMLZListController ()


@end

@implementation PNMLZListController

+ (void)load{
    titles = [[NSMutableArray alloc] init];
    titleWithHandlers = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setInterfaceOrientation:UIInterfaceOrientationLandscapeRight];

}
//必须返回YES
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        // 从2开始是因为前两个参数已经被selector和target占用
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Register Methods

+ (void)registerWith:(NSString *)title handler:(ViewControllerHandler)handler{
    if (!title) return;
    [titles addObject:title];
    titleWithHandlers[title] = handler;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    UIViewController *vc = ((ViewControllerHandler)titleWithHandlers[titles[indexPath.row]])();
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods

- (void)setupUI{
    [super setupUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

@end
