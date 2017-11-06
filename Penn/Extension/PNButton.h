//
//  PNButton.h
//  Penn
//
//  Created by SanRong on 2017/11/4.
//  Copyright © 2017年 SanRong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, PNButtonContentMode){
    PNButtonContentModeDefault,
    PNButtonContentModeRightImage,
    PNButtonContentModeTopImage,
    PNButtonContentModeBottomImage
};

@interface PNButton : UIButton

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) PNButtonContentMode contentMode;

@end
