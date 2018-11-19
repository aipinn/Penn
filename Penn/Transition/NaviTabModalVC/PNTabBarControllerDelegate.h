//
//  PNTabBarDelegate.h
//  Penn
//
//  Created by emoji on 2018/10/18.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNTabBarControllerDelegate : NSObject<UITabBarControllerDelegate>

/**
 是否可以交互
 */
@property (nonatomic, assign) BOOL interactive;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionTrans;


@end

NS_ASSUME_NONNULL_END
