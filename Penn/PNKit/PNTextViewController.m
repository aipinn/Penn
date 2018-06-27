//
//  PNTextViewController.m
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNTextViewController.h"
#import "PNFillTextView.h"

#define kQQuestionText  @"晶体的对称性可由____点群表征，晶体的排列可分为____种布喇菲格子，其中六角密积结构____布喇菲格子____。"
#define kAnsQuestionText  @"晶体的对称性可由____点群表征，晶体的排列可分为不知道种布喇菲格子，其中六角密积结构8956sadjfhs撒大哥级布喇菲格子1234。"


@interface PNTextViewController ()<PNFillViewDelegate>
@property (nonatomic, strong) PNFillTextView * textView;

@end

@implementation PNTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{
    
    PNFillTextView * textView = [[PNFillTextView alloc] initWithFrame:CGRectMake(10, 88, SCREEN_WIDTH-20, SCREEN_WIDTH)
                                                                 text:kQQuestionText ansText:kQQuestionText];
    textView.delefate = self;
    textView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:textView];
    self.textView = textView;
//    textView.ansText = kAnsQuestionText;
    
    
}

- (void)fillViewAccViewDidComplete:(NSString *)content tapText:(NSString *)tapText range:(NSRange)range Info:(NSDictionary *)info{
    
    if ([self.textView.text isEqualToString:self.textView.ansText]) {
        NSString * newText =  [self.textView.text stringByReplacingOccurrencesOfString:tapText withString:content options:0 range:range];
        self.textView.ansText = newText;

    }else{
        NSString * newText =  [self.textView.ansText stringByReplacingOccurrencesOfString:tapText withString:content options:0 range:range];
        self.textView.ansText = newText;
    }
    
}

- (void)dealloc{
    
}
@end
