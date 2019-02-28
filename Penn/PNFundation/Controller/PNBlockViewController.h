//
//  PNBlockViewController.h
//  Penn
//
//  Created by emoji on 2018/8/13.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "BaseViewController.h"

@interface PNBlockViewController : BaseViewController

@end

typedef void (^Ok_block)(void);

@interface OkBlock : NSObject

@property (nonatomic, copy) Ok_block block;
@property (nonatomic, copy) NSArray * array;

- (void)exeBlock;

@end
