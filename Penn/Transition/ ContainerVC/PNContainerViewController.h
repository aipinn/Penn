//
//  PNContainerViewController.h
//  Penn
//
//  Created by emoji on 2018/10/19.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNContainerViewController : UIViewController

@property (nonatomic, copy, readonly) NSArray *viewControllers;

@property (nonatomic, strong) UIViewController *selectedViewController;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end

NS_ASSUME_NONNULL_END
