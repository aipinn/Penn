//
//  UINavigationController+Add.h
//  HomeEconomics
//
//  Created by emoji on 2018/12/6.
//  Copyright © 2018 guanjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JYNavigationBarBackDelegate <NSObject>

@optional
- (BOOL)navigationBarShouldPopOnBackClicked;

@end

@interface UIViewController(Add)<JYNavigationBarBackDelegate>

@end

@interface UINavigationController (Add)


@end

NS_ASSUME_NONNULL_END
