//
//  PNTextViewController.m
//  Penn
//
//  Created by emoji on 2018/6/26.
//  Copyright © 2018年 PENN. All rights reserved.
//

#import "PNTextViewController.h"
#import "PNFillTextView.h"

#define kQQuestionText  @"____晶体的对称性可由____点群表征，晶体的排列可分为____种布喇菲格子，其中六角密积结构____布喇菲格子____。"


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
    
    PNFillTextView * textView = [[PNFillTextView alloc] init];
    textView.frame = CGRectMake(0, 88, 300, 300);
    textView.text = kQQuestionText;
    textView.delefate = self;
    textView.backgroundColor = [UIColor orangeColor];
    self.textView = textView;
    [self.view addSubview:textView];

    
    
}

- (void)fillViewAccViewDidComplete:(NSString *)content tapText:(NSString *)tapText range:(NSRange)range model:(PNFillModel*)model Info:(NSDictionary *)info{
    if ([content isEqualToString:@""]) {
        content = @"____";
    }
   
    NSString * newText =  [self.textView.text stringByReplacingOccurrencesOfString:tapText withString:content options:0 range:range];
    model.text = content;
    [self.textView resetDataSource:model];
    self.textView.text = newText;
   
}

- (void)dealloc{
    
}
@end
