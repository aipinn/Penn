//
//  PNButton.h
//  Penn
//
//  Created by PENN on 2017/11/4.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(UIButton *button);

typedef NS_ENUM(NSInteger, PNButtonContentMode){
    PNButtonContentModeDefault,
    PNButtonContentModeRightImage,
    PNButtonContentModeTopImage,
    PNButtonContentModeBottomImage
};

@interface PNButton : UIButton

@property(nonatomic, assign) CGSize imageSize;
@property(nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) PNButtonContentMode pn_contentMode;

@property (nonatomic, copy) Block callBack;

- (void)buttonImage:(NSString *)string title:(NSString *)title;
- (void)buttonImage:(NSString *)string highlightedImage:(NSString *)highStr title:(NSString *)title;
- (void)buttonImage:(NSString *)string selectedImage:(NSString *)highStr title:(NSString *)title selectedTitle:(NSString *)selectedTitle;


@end
