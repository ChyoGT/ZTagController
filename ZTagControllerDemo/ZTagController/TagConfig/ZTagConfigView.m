//
//  ZTagConfigView.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/8.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZTagConfigView.h"

@interface ZTagConfigView ()


@property (nonatomic, weak) UIButton * saveButton;

@end

@implementation ZTagConfigView

+ (instancetype)tagConfigView {
    ZTagConfigView * tagConfigView = [[self alloc] init];
    [tagConfigView setupTagConfigView];
    return tagConfigView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        _saveButton = button;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)saveButtonClick {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setupTagConfigView {
    
    UIView * windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0;
    self.frame = CGRectMake(0, 0, windowView.bounds.size.width, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = windowView.bounds;
        self.alpha = 0.95;
    }];
    
}

- (void)layoutSubviews {
    
    CGFloat btnWidth = 60;
    self.saveButton.frame = CGRectMake(self.frame.size.width - btnWidth - 10, 20, btnWidth, 40);
}

@end
