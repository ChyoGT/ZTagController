//
//  ZTagsView.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZTagsView.h"
#import "ZTagConst.h"

#define kAnimationMoveDuration 0.5
#define kAnimationFontDuration 0.3

@interface ZTagsView ()

@property (nonatomic, weak) UIScrollView *tagsScrollView;

@property (nonatomic, weak) UIButton * configButton;

@property (nonatomic, weak) UIButton * currentSelectedButton;

@property (nonatomic, strong) NSMutableArray * buttons;

@end

@implementation ZTagsView

#pragma mark - 构造函数
+ (instancetype)tagsView {
    return [[self alloc] init];
}

#pragma mark - 生命周期函数
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tagsScrollView.frame = CGRectMake(0, 0, self.frame.size.width - ZTagViewHeight, ZTagViewHeight);
    
    CGFloat maxX = ZTagButtonMargin;
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        button.frame = CGRectMake(maxX, 0, ZTagButtonWidth, ZTagButtonHeight);
        maxX += ZTagButtonWidth + ZTagButtonMargin;
    }
    
    self.configButton.frame = CGRectMake(CGRectGetMaxX(self.tagsScrollView.frame), 0, ZTagViewHeight, ZTagViewHeight);
}

#pragma mark - setter
- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    CGFloat contentSizeWidth = tags.count * ZTagButtonWidth + (tags.count + 1) * ZTagButtonMargin;
    self.tagsScrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    
    long count = tags.count - self.buttons.count;
    for (NSUInteger i = 0; i < (count > 0 ? count : -count); i++) {
        if (count > 0) {
            [self addTagButton];
        } else {
            [self.buttons.lastObject removeFromSuperview];
            [self.buttons removeLastObject];
        }
    }
    
    for (int i = 0; i < tags.count; i++) {
        [self.buttons[i] setTitle:tags[i] forState:UIControlStateNormal];
    }
    
    [self setNeedsLayout];
    if (self.buttons.count > 0) {
        self.currentSelectedButton = self.buttons[0];
    }
}

- (void)addTagButton{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tagsScrollView addSubview:button];
    [button setTitleColor:ZTagButtonColorNormal forState:UIControlStateNormal];
    [button setTitleColor:ZTagButtonColorSelected forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = ZTagButtonFontNormal;
    button.adjustsImageWhenHighlighted = NO;
    [self.buttons addObject:button];
}

- (void)setCurrentSelectedButton:(UIButton *)currentSelectedButton {
    
    [self revertButtonAnimation:_currentSelectedButton];
    _currentSelectedButton.selected = NO;
    
    currentSelectedButton.selected = YES;
    _currentSelectedButton = currentSelectedButton;
    
    [self buttonAnimation:currentSelectedButton];
    [self moveAnimation:currentSelectedButton];
}



- (void)setCurrentTagIndex:(NSInteger)currentTagIndex {
    
    _currentTagIndex = currentTagIndex;
    
    self.currentSelectedButton = self.buttons[currentTagIndex];
}

#pragma mark - getter
- (UIScrollView *)tagsScrollView {
    
    if (_tagsScrollView == nil) {
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        _tagsScrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _tagsScrollView;
}

- (UIButton *)configButton {
    if (_configButton == nil) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        _configButton = button;
        [button setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configButton;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

#pragma mark - 点击触发事件
- (void)tagButtonClick:(UIButton *)button {
    
    if (button.isSelected) {
        if ([self.tagDelegate respondsToSelector:@selector(tagsViewSelectedTagDidClick:)]) {
            [self.tagDelegate tagsViewSelectedTagDidClick:self];
        }
        return;
    }
    
    self.currentSelectedButton = button;
    
    if ([self.tagDelegate respondsToSelector:@selector(tagsView:tagDidSelected:)]) {
        [self.tagDelegate tagsView:self tagDidSelected:[self.buttons indexOfObject:button]];
    }
}

- (void)configButtonClick {
    if ([self.tagDelegate respondsToSelector:@selector(tagsViewConfigButtonDidClick:)]) {
        [self.tagDelegate tagsViewConfigButtonDidClick:self];
    }
}

#pragma mark - 按钮动画效果
- (void)buttonAnimation:(UIButton *)button {
    [UIView animateWithDuration:kAnimationFontDuration animations:^{
        
        // frame
        button.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
        // font size
        button.titleLabel.font = ZTagButtonFontSelected;
    }];
}

- (void)revertButtonAnimation:(UIButton *)button {
    [UIView animateWithDuration:kAnimationFontDuration animations:^{
        
        // frame
        button.transform = CGAffineTransformIdentity;
        
        // font size
        button.titleLabel.font = ZTagButtonFontNormal;
    }];
}

- (void)moveAnimation:(UIButton *)button {
    
    [UIView animateWithDuration:kAnimationMoveDuration animations:^{
        
        if ([self canMoveToCenterWithCGPoint:button.center]) {
            [self.tagsScrollView setContentOffset:CGPointMake(button.center.x - self.tagsScrollView.frame.size.width * 0.5, 0)];
        } else {
            
            CGFloat offset = [self convertPoint:button.center fromView:self.tagsScrollView].x - self.center.x;
            if (offset > 0) {
                [self.tagsScrollView setContentOffset:CGPointMake(self.tagsScrollView.contentSize.width - self.tagsScrollView.frame.size.width, 0)];
            } else {
                [self.tagsScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }
    }];
}

- (BOOL)canMoveToCenterWithCGPoint:(CGPoint)point {
    
    CGFloat offset = [self convertPoint:point fromView:self.tagsScrollView].x - self.center.x;
    if (offset > 0) {
        if (offset < self.tagsScrollView.contentSize.width - self.tagsScrollView.contentOffset.x - self.tagsScrollView.frame.size.width) {
            return YES;
        }
    } else {
        if (-offset < self.tagsScrollView.contentOffset.x) {
            return YES;
        }
    }
    return NO;
}

@end
