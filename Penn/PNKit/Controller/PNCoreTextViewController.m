//
//  PNCoreTextViewController.m
//  Penn
//
//  Created by emoji on 2018/7/27.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNCoreTextViewController.h"
#import "PNCTDisplayView.h"
#import "PNCTFrameParser.h"
#import "PNCTFrameParserConfig.h"
#import "UIViewController+PNAdd.h"

@interface PNCoreTextViewController ()
@property (weak, nonatomic) IBOutlet PNCTDisplayView *coreTextView;

@end

@implementation PNCoreTextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSString * context = @"CoreText是用于处理文字和字体的底层技术。它直接和Core Graphics(又被称为Quartz)打交道。Quartz是一个2D图形渲染引擎，能够处理OSX和iOS中图形显示问题。Quartz能够直接处理字体（font）和字形（glyphs），将文字渲染到界面上，它是基础库中唯一能够处理字形的模块。\n\n因此CoreText为了排版，需要将显示的文字内容、位置、字体、字形直接传递给Quartz。与其他UI组件相比，由于CoreText直接和Quartz来交互，所以它具有更高效的排版功能。";
    PNCTFrameParserConfig * config = [[PNCTFrameParserConfig alloc]init];
    config.textColor = [UIColor orangeColor];
    config.width = self.coreTextView.width;
    config.fontSize = 18.0;
    
    /*
    PNCoreTextData * data = [PNCTFrameParser parserContext:context config:config];
    self.coreTextView.data = data;
    self.coreTextView.height = data.height;
    self.coreTextView.backgroundColor = [UIColor orangeColor];
    */

    /*
    NSDictionary * attr = [PNCTFrameParser attributesWithConfig:config];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:context
                                                                                         attributes:attr];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 15)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(20, 20)];
    [attributeString addAttribute:NSBackgroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(40, 30)];
    
    PNCoreTextData * data = [PNCTFrameParser paraserAttributesContext:attributeString config:config];
    self.coreTextView.data = data;
    self.coreTextView.height = data.height;
    self.coreTextView.backgroundColor = [UIColor whiteColor];
    */
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    PNCoreTextData * data = [PNCTFrameParser parserTemplateFile:path config:config];
    self.coreTextView.data = data;
    self.coreTextView.height = data.height;
    //图片点击通知
    [self setupNotifications];
    
    //测试键盘可以正常弹出
    UITextField * textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(0, 600, 100, 50);
    [self.view addSubview:textField];
    textField.backgroundColor = [UIColor grayColor];
    
    NSLog(@"%@",[[YYClassInfo classInfoWithClass:self.coreTextView.class] ivarInfos]);

}
- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectedTapImage:) name:PNCTDisplayViewImageTapedNOtification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectedTapLink:) name:PNCTDisplayViewLinkTapedNotification object:nil];
}

- (void)detectedTapImage:(NSNotification *)notify{
    NSLog(@"taped image:%@", notify.userInfo[@"imageData"]);
}
- (void)detectedTapLink:(NSNotification *)notify{
    NSLog(@"taped link:%@", notify.userInfo[@"linkData"]);
    
    if(self.coreTextView.window && [self.coreTextView canBecomeFirstResponder]){
        BOOL ret =  [self.coreTextView becomeFirstResponder];
        if (ret) {
            [self.coreTextView reloadInputViews];
        }
        NSLog(@"%d", ret);
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
