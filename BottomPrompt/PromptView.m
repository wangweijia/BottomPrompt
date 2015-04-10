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
//分享控件
@property (nonatomic, weak) UIView *shareView;

@property (nonatomic, assign) BOOL isShow;
@end

@implementation PromptView

- (instancetype)init{
    if (self = [super init]) {
        self.BtnArray = [NSMutableArray array];
        self.LabelArray = [NSMutableArray array];
        self.backgroundColor = [UIColor yellowColor];
        [self setIsShow:NO];
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
/**
 *  初始化 背景view
 */
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
/**
 *  初始化 分享部分按钮
 */
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
/**
 *  显示 时加载 各控件尺寸
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self initFrame];
}
/**
 *  初始化各控件 frame
 */
- (void)initFrame{
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
    CGFloat copyBtnW = [_CopyBtn.titleLabel.text sizeWithFont:_CopyBtn.titleLabel.font].width + 10.0;
    CGFloat copyBtnH = [_CopyBtn.titleLabel.text sizeWithFont:_CopyBtn.titleLabel.font].height + 10.0;
    CGFloat copyBtnX = (DEVICE_SCREEN_WIDTH - copyBtnW) / 2.0;
    UILabel *lab = [_LabelArray lastObject];
    CGFloat copyBtnY = CGRectGetMaxY(lab.frame) + 30.0;
    [self.CopyBtn setFrame:CGRectMake(copyBtnX, copyBtnY, copyBtnW, copyBtnH)];
    
    UIImage *bgNormal = [UIImage imageNamed:@"border_btn01"];
    UIEdgeInsets insetNormal = UIEdgeInsetsMake((bgNormal.size.height-1)/2, (bgNormal.size.width-1)/2, (bgNormal.size.height+1)/2, (bgNormal.size.width+1)/2);
    
    UIImage *bgHighlighted = [UIImage imageNamed:@"settingbtn03"];
    UIEdgeInsets insetHighlighted = UIEdgeInsetsMake((bgHighlighted.size.height-1)/2, (bgHighlighted.size.width-1)/2, (bgHighlighted.size.height+1)/2, (bgHighlighted.size.width+1)/2);
    
    [self.CopyBtn setBackgroundImage:[bgNormal resizableImageWithCapInsets:insetNormal] forState:UIControlStateNormal];
    [self.CopyBtn setBackgroundImage:[bgHighlighted resizableImageWithCapInsets:insetHighlighted] forState:UIControlStateHighlighted];
    
    
    //计算整个控件的高度
    CGFloat viewH = CGRectGetMaxY(_CopyBtn.frame) + BETWEEN;
//        CGFloat viewY = DEVICE_SCREEN_HEIGHT - viewH;
    self.shareView.frame = CGRectMake(0, DEVICE_SCREEN_HEIGHT, DEVICE_SCREEN_WIDTH, viewH);
    
    if (!_isShow) {
        [self animateIn];
    }
    [self setIsShow:YES];
}
/**
 *  分享按钮点击事件
 *
 *  @param sender 按钮
 */
- (void)shareBtnClick:(UIButton *)sender{
    NSLog(@"share按钮");
    if ([self.delegate respondsToSelector:@selector(shareBtnClicked:)]) {
        [self.delegate shareBtnClicked:sender];
    }
    [self end];
}
/**
 *  拷贝按钮点击事件
 *
 *  @param sender 按钮
 */
- (void)copyBtnClick:(UIButton *)sender{
    NSLog(@"copy按钮");
    if ([self.delegate respondsToSelector:@selector(copyBtnClicked:)]) {
        [self.delegate copyBtnClicked:sender];
    }
    [self end];
}
/**
 *  空白部分点击事件
 *
 *  @param sender 按钮
 */
- (void)Actiondo:(id)sender{
    NSLog(@"点击事件");
    [self end];
}
/**
 *  显示分享控件
 */
- (void)show{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self setNeedsLayout];
    
}
/**
 *  结束分享控件
 */
- (void)end{
    [self animateOut];
}

-(void)animateIn{
    CGFloat H = self.shareView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformTranslate(_shareView.transform, 0, -H);
    }];
}

-(void)animateOut{
    CGFloat H = self.shareView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformTranslate(_shareView.transform, 0, H);
    } completion:^(BOOL finished) {
        [self setIsShow:NO];
        [self removeFromSuperview];
    }];
}

@end
