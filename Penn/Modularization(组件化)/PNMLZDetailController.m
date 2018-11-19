//
//  PNMLZDetailController.m
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "PNMLZDetailController.h"
#import "PNMLZListController.h"
#import "PNRouter.h"

@interface PNMLZDetailController ()

@property (nonatomic) SEL selector;

@end

@implementation PNMLZDetailController

+ (void)load{

    PNMLZDetailController *detailVc = [[PNMLZDetailController alloc]init];
    [PNMLZListController registerWith:@"基本使用" handler:^UIViewController *{
        detailVc.selector = @selector(ml_basicUse);
        return detailVc;
    }];
    
    [PNMLZListController registerWith:@"中文匹配" handler:^UIViewController *{
        detailVc.selector = @selector(ml_chineseChar);
        return detailVc;
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:self.selector withObject:nil afterDelay:0];
}

#pragma mark - Actions

- (void)ml_basicUse{
    [PNRouter registerURLPattern:@"pinn://foo/evening" toHandler:^(NSDictionary * _Nonnull routerParameters) {
        
    }];
    [PNRouter openURL:@"pinn://foo/"];
}

- (void)ml_chineseChar{
    
}
@end
