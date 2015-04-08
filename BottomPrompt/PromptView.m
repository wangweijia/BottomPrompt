//
//  PromptView.m
//  BottomPrompt
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import "PromptView.h"

@interface PromptView()

//按钮宽度
@property (nonatomic, assign) CGFloat BtnWH;
//按钮数组
@property (nonatomic, strong) NSMutableArray *BtnArray;
//label数组
@property (nonatomic, strong) NSMutableArray *LabelArray;
//下方 地址复制 按钮
@property (nonatomic, weak) UIButton *CopyBtn;

@property (nonatomic, weak) UIView *shareView;
@end

@implementation PromptView

- (instancetype)init{
    if (self = [super init]) {
        self.BtnArray = [NSMutableArray array];
        self.LabelArray = [NSMutableArray array];
        self.backgroundColor = [UIColor yellowColor];
        
        [self initBgView];
    }
    return self;
}

- (void)setColumns:(NSInteger)columns{
    _columns = columns;
    //计算每个按钮宽高，正方形
    self.BtnWH = (DEVICE_SCREEN_WIDTH - BETWEEN) / (CGFloat)_columns  - BETWEEN;
}

- (void)setItemDic:(NSDictionary *)itemDic{
    _itemDic = itemDic;
    [self initControl];
}

- (void)initBgView{
    [self setFrame:[[UIScreen mainScreen] bounds]];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    [self addGestureRecognizer:tapGesture];
    
    UIView *shareView = [[UIView alloc] init];
    [shareView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:shareView];
    [self setShareView:shareView];
}

- (void)initControl{
    NSArray *nameKey = [_itemDic allKeys];
    for (NSInteger i = 0; i < nameKey.count; i++) {
        
        //初始化列表按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:_itemDic[nameKey[i]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_itemDic[nameKey[i]]] forState:UIControlStateHighlighted];
        [btn setTag:i];
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:btn];
        [self.BtnArray addObject:btn];
        
        //初始化Label
        UILabel *lable = [[UILabel alloc] init];
        lable.text = nameKey[i];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        [self.shareView addSubview:lable];
        [self.LabelArray addObject:lable];
    }
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制链接" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:copyBtn];
    [self setCopyBtn:copyBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //按钮与label的布局
    NSInteger j = 0;
    for (NSInteger i = 0; i < _itemDic.count; i++) {
        
        UIButton *btn = _BtnArray[i];
        UILabel *lab = _LabelArray[i];
        CGFloat LabH = [lab.text sizeWithFont:lab.font].height;
        
        j = i / _columns;
        NSInteger tempI = i % _columns;
        
        //btn frame
        CGFloat btnX = BETWEEN * (tempI + 1) + tempI * _BtnWH;
        CGFloat btnY = BETWEEN * (j + 1) + j * (_BtnWH + LabH );
        [btn setFrame:CGRectMake(btnX, btnY, _BtnWH, _BtnWH)];
        
        //Lable frame
        CGFloat LabX = btnX;
        CGFloat LabY = CGRectGetMaxY(btn.frame);
        CGFloat LabW = btn.frame.size.width;
        [lab setFrame:CGRectMake(LabX, LabY, LabW, LabH)];
        
    }
    
    //下方单独按钮
    CGFloat copyBtnW = [_CopyBtn.titleLabel.text sizeWithFont:_CopyBtn.titleLabel.font].width;
    CGFloat copyBtnH = [_CopyBtn.titleLabel.text sizeWithFont:_CopyBtn.titleLabel.font].height;
    CGFloat copyBtnX = (DEVICE_SCREEN_WIDTH - copyBtnW) / 2.0;
    UILabel *lab = [_LabelArray lastObject];
    CGFloat copyBtnY = CGRectGetMaxY(lab.frame) + 30.0;
    [self.CopyBtn setFrame:CGRectMake(copyBtnX, copyBtnY, copyBtnW, copyBtnH)];
    
    
    //计算整个控件的高度
    CGFloat viewH = CGRectGetMaxY(_CopyBtn.frame) + BETWEEN;
    CGFloat viewY = DEVICE_SCREEN_HEIGHT - viewH;//20:头部导航栏高度
    self.shareView.frame = CGRectMake(0, viewY, DEVICE_SCREEN_WIDTH, viewH);
}

- (void)shareBtnClick:(UIButton *)sender{
    NSLog(@"share按钮");
    if ([self.delegate respondsToSelector:@selector(shareBtnClicked:)]) {
        [self.delegate shareBtnClicked:sender];
    }
    [self end];
}

- (void)copyBtnClick:(UIButton *)sender{
    NSLog(@"copy按钮");
    if ([self.delegate respondsToSelector:@selector(copyBtnClicked:)]) {
        [self.delegate copyBtnClicked:sender];
    }
    [self end];
}

- (void)Actiondo:(id)sender{
    NSLog(@"点击事件");
    [self end];
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)end{
    [self removeFromSuperview];
}

@end
