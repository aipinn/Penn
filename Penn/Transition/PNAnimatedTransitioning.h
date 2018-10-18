//
//  PNAnimatedTransitioningDelegete.h
//  Penn
//
//  Created by emoji on 2018/10/15.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PNTransitionOperationType) {
    PNTransitionOperationTypePush,
    PNTransitionOperationTypePop,
    PNTransitionOperationTypeLeft,//向左切换1-->2
    PNTransitionOperationTypeRight,//向右切换2-->1
    PNTransitionOperationTypePresent,
    PNTransitionOperationTypeDismiss
};
@interface PNAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PNTransitionOperationType operationType;

@end

NS_ASSUME_NONNULL_END
