//
//  PromptView.m
//  PromptView
//
//  Created by 施峰磊 on 2017/3/24.
//  Copyright © 2017年 sfl. All rights reserved.
//

#import "PromptView.h"

static PromptView *_promptView;
#define APPSIZE [[UIScreen mainScreen] bounds].size
@interface PromptView()
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) NSOperationQueue      *queue;//显示队列
@end

@implementation PromptView

+ (PromptView *)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _promptView = [[self alloc] init];
        _promptView.alpha = 0.0;
        _promptView.hidden = YES;
    });
    return _promptView;
}

- (void)dealloc{
    [self.queue removeObserver:self forKeyPath:@"operations"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
        [self addViews];
        [self addNotification];
    }
    return self;
}


- (void)addViews{
    [self addSubview:self.titleLabel];
}

- (void)configView{
    self.showPositionBottom = 70.0;
    self.showTime = 3.0f;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        [_queue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _queue;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

/**
 *	@author 施峰磊, 16-08-04 15:08:08
 *
 *	TODO:显示提示
 *
 *	@since 2.9
 */
- (void)showPrompt{
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [self.layer removeAllAnimations];
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished && !self.PopUpOneByOne){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenPrompt) object:nil];
            [self performSelector:@selector(hiddenPrompt) withObject:nil afterDelay:self.showTime];
        }
    }];
}

/**
 TODO:隐藏提示
 */
- (void)hiddenPrompt{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}


/**
 TODO:设置文字

 @param text 文字
 */
- (void)setText:(NSString *)text{
    if (self.PopUpOneByOne) {
        [self setTitleOperationWithTitle:text];
    }else{
        [self sizeCalculationWithText:text];
    }
}

- (void)setTitleOperationWithTitle:(NSString *)title{
    titleOperation *operation = [[titleOperation alloc] initWithTitle:title];
    [self.queue addOperation:operation];
}

- (void)sizeCalculationWithText:(NSString *)text{
    CGSize size = [text boundingRectWithSize:CGSizeMake(APPSIZE.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
    self.frame = CGRectMake(APPSIZE.width/2.0-(size.width+10.0)/2.0, APPSIZE.height-self.showPositionBottom-(size.height+10), size.width+10, size.height+10);
    self.titleLabel.frame = CGRectMake(5, 5, size.width, size.height);
    self.titleLabel.text = text;
}

- (void)orientChange:(NSNotification *)notification{
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.superview) {
        self.center = CGPointMake(APPSIZE.width/2.0, APPSIZE.height-self.showPositionBottom-CGRectGetHeight(self.frame)/2.0);
    }
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.queue && [keyPath isEqualToString:@"operations"]){
        if (0 == self.queue.operations.count){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hiddenPrompt];
            });
        }
    }
}


@end

@interface titleOperation ()

@property (nonatomic, strong)NSString *title;

@end

@implementation titleOperation
- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}


- (void)main{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PromptView singleton] sizeCalculationWithText:self.title];
    });
    [NSThread sleepForTimeInterval:[PromptView singleton].showTime];
}

@end
