//
//  PNRouter.h
//  Penn
//
//  Created by pinn on 2018/10/11.
//  Copyright © 2018 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const PNRouterParameterURL;
extern NSString *const PNRouterParameterCompletion;
extern NSString *const PNRouterParameterUserInfo;

typedef void (^PNRoterHandler)(NSDictionary *routerParameters);

@interface PNRouter : NSObject

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(PNRoterHandler)handler;

@end

NS_ASSUME_NONNULL_END
