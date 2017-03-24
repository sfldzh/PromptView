//
//  PromptView.h
//  PromptView
//
//  Created by 施峰磊 on 2017/3/24.
//  Copyright © 2017年 sfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface titleOperation : NSOperation
- (instancetype)initWithTitle:(NSString *)title;
@end


@interface PromptView : UIView
//显示位置（以底部为准)
@property (nonatomic, assign)CGFloat showPositionBottom;
//显示时间
@property (nonatomic, assign)CGFloat showTime;
//文本
@property (nonatomic, strong)NSString *text;
//是否队列弹出
@property (nonatomic, assign)BOOL PopUpOneByOne;

+ (PromptView *)singleton;

/**
 *	@author 施峰磊, 16-08-04 15:08:08
 *
 *	TODO:显示提示
 *
 *	@since 2.9
 */
- (void)showPrompt;

- (void)sizeCalculationWithText:(NSString *)text;
@end


