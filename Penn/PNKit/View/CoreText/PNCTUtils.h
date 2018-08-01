//
//  PNCTUtils.h
//  Penn
//
//  Created by emoji on 2018/8/1.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNCoreTextData.h"
#import "PNCTLinkData.h"

@interface PNCTUtils : NSObject

/**
 检测用户点击是否在链接上
 */
+ (PNCTLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(PNCoreTextData *)data;

@end
