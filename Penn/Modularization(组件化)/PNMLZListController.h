//
//  PNMLZListController.h
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//typedef int (^MLZCallBack)(void);
typedef UIViewController *(^ViewControllerHandler)(void);

@interface PNMLZListController : BaseViewController

+ (void)registerWith:(NSString *)title handler:(ViewControllerHandler)handler;

@end

NS_ASSUME_NONNULL_END
