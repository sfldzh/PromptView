//
//  ViewController.m
//  PromptView
//
//  Created by 施峰磊 on 2017/3/24.
//  Copyright © 2017年 sfl. All rights reserved.
//

#import "ViewController.h"
#import "PromptView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *arrary = @[@"对的",@"错的",@"今天的",@"明天的",@"后天的",@"而山东省环保厅常年法律顾问、北京德恒（济南）律师事务所律师宋俊博告诉澎湃新闻：“环境质量标准和污染物排放标准里边，均没有氯化物指标。农业灌溉用水标准，是对用于灌溉的水的质量要求，而不是所有的水必须达到标准。 经山东省环境保护厅调查，相关水域指标正常，未发现相关企业违法排污行为，无法调解。”"];
    [PromptView singleton].PopUpOneByOne = YES;
//    [PromptView singleton].showTime = 20;
    for (NSString *title in arrary) {
        [PromptView singleton].text = title;
        [[PromptView singleton] showPrompt];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
