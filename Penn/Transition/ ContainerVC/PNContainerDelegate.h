//
//  PNContainerDelegate.h
//  Penn
//
//  Created by pinn on 2018/10/21.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNContainerViewController.h"
#import "PNPercentDrivenInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface PNContainerDelegate : NSObject<PNContainerControllerDelegate>

@property (nonatomic, assign) BOOL interactive;//是否支持交互式转场

@property (nonatomic, strong) PNPercentDrivenInteractiveTransition * interactionTrans;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition * interactionTransOld;


@end

NS_ASSUME_NONNULL_END
