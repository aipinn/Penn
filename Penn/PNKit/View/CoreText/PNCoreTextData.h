//
//  PNCoreTextData.h
//  Penn
//
//  Created by emoji on 2018/7/30.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNCTImageData.h"

@interface PNCoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSAttributedString * context;

@property (nonatomic, strong) NSArray * imageArray;

@end
