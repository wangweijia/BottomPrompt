//
//  PromptView.h
//  BottomPrompt
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 com.eku001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol promptViewDelegate <NSObject>
@optional
//分享按钮代理
- (void)shareBtnClicked:(UIButton *)btn;
//复制链接按钮代理
- (void)copyBtnClicked:(UIButton *)btn;
@end

//各按钮的间距
#define BETWEEN 10.0
//设备屏幕宽度
#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//设备屏幕高度
#define DEVICE_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PromptView : UIView
//列数
@property (nonatomic, assign) NSInteger columns;
//存放图标
@property (nonatomic, strong) NSDictionary *itemDic;
//代理
@property (nonatomic, assign) id<promptViewDelegate> delegate;

- (void)show;

@end
