//
//  PNLoginView.h
//  Penn
//
//  Created by SanRong on 2017/12/2.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNLoginView : UIView

@property (weak, nonatomic) IBOutlet UIButton *close;
+ (PNLoginView *)loginView;

@end
