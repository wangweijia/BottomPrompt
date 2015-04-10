//
//  ViewController.m
//  BottomPrompt
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "ViewController.h"
//#import "Prompt.h"
#import "PromptView.h"

@interface ViewController ()<promptViewDelegate>

//@property (nonatomic, strong) Prompt *prompt;
@property (nonatomic, strong) PromptView *promptView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //名字 与 图片名字
    NSDictionary *dic = @{@"新浪微博":@"sinaicon",@"QQ好友":@"qqicon",@"朋友圈":@"wechattimeline",@"微信好友":@"wechaticon",@"QQ空间":@"qzoneicon"};
    
    self.promptView = [[PromptView alloc] init];
    [self.promptView setDelegate:self];
    [self.promptView setColumns:4];
    [self.promptView setItemDic:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicks:(id)sender {
    [self.promptView show];
}

//分享按钮代理
- (void)shareBtnClicked:(UIButton *)btn{
}
//复制链接按钮代理
- (void)copyBtnClicked:(UIButton *)btn{
}

@end
