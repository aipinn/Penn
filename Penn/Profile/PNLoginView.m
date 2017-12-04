//
//  PNLoginView.m
//  Penn
//
//  Created by SanRong on 2017/12/2.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import "PNLoginView.h"

@implementation PNLoginView

+ (PNLoginView *)loginView{
    
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"PNLoginView" owner:nil options:nil];
    PNLoginView * v = arr.firstObject;
    return v;
}

- (IBAction)closeClicked:(UIButton *)sender {

    POPSpringAnimation * rotation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.fromValue = @(0);
    rotation.toValue = @(M_PI * 3);
    //旋转要添加到layer
    [sender.layer pop_addAnimation:rotation forKey:nil];
    rotation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        //1. create
        POPSpringAnimation * spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        //2. set property
        spring.fromValue = @(self.frame.origin.y);
        spring.toValue = @(SCREEN_HEIGHT+100);
        //3. add anim
        [self pop_addAnimation:spring forKey:@"fade"];
        //4. finish
        spring.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            [self removeFromSuperview];
        };
    };
    
    
}



@end
