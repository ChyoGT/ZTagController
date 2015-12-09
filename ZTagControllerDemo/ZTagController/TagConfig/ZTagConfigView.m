//
//  ZTagConfigView.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/8.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZTagConfigView.h"

#define kLabelFont [UIFont systemFontOfSize:13]
#define kLabelMargin 10
#define kLabelColumn 4
#define kLabelHeight 40
#define kLineViewHeight 1

@interface ZTagConfigView ()

@property (nonatomic, weak) UIButton * saveButton;

@property (nonatomic, strong) NSMutableArray * selectedTags;
@property (nonatomic, strong) NSMutableArray * unselectedTags;

@property (nonatomic, strong) NSMutableArray * selectedLabels;
@property (nonatomic, strong) NSMutableArray * unSelectedLabels;

@property (nonatomic, weak) UIView * lineView;

@end

@implementation ZTagConfigView
{
    // 动画Flg
    BOOL _animFlg;
    // View高度
    CGFloat _viewHeight;
}

#pragma mark - 构造函数
+ (instancetype)tagConfigView {
    ZTagConfigView * configView = [[self alloc] init];
    configView.backgroundColor = [UIColor whiteColor];
    return configView;
}

- (void)showTagConfigViewWithSelectedTags:(NSArray *)selectedArray tags:(NSArray *)tags {
    [self.selectedTags addObjectsFromArray:selectedArray];
    for (NSString * tag in tags) {
        if ([selectedArray containsObject:tag]) continue;
        [self.unselectedTags addObject:tag];
    }
    
    [self setupLabels];
    [self showConfigView];
}

- (void)showConfigView {
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        CGRect frame = self.frame;
        frame.size.height = _viewHeight;
        self.frame = frame;
    }];
}

+ (void)showTagConfigViewWithSelectedTags:(NSArray *)selectedArray tags:(NSArray *)tags {
    ZTagConfigView * configView = [self tagConfigView];
    [configView.selectedTags addObjectsFromArray:selectedArray];
    for (NSString * tag in tags) {
        if ([selectedArray containsObject:tag]) continue;
        [configView.unselectedTags addObject:tag];
    }
    
    [configView setupLabels];
}

#pragma mark - 生命周期函数
- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width, 0);
    _viewHeight = newSuperview.bounds.size.height;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat maxY = 0;
    CGFloat btnWidth = 60;
    self.saveButton.frame = CGRectMake(self.frame.size.width - btnWidth - 10, 20, btnWidth, 40);
    maxY = CGRectGetMaxY(self.saveButton.frame);
    
    CGFloat labelWidth = (self.frame.size.width - kLabelMargin * (kLabelColumn + 1)) / kLabelColumn;
    
    if (_animFlg) {
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutViewsWithMaxY:maxY labelWidth:labelWidth];
        } completion:^(BOOL finished) {
            _animFlg = NO;
        }];
    } else {
        [self layoutViewsWithMaxY:maxY labelWidth:labelWidth];
    }
}

- (void)layoutViewsWithMaxY:(CGFloat)maxY labelWidth:(CGFloat)labelWidth {
    for (int i = 0; i < self.selectedLabels.count; i++) {
        UILabel * label = self.selectedLabels[i];
        [self setupLabelFrameWithLabel:label index:i maxY:maxY width:labelWidth];
        if (i == self.selectedLabels.count - 1) {
            maxY = CGRectGetMaxY(label.frame);
        }
    }
    
    self.lineView.frame = CGRectMake(10, maxY + kLabelMargin, self.frame.size.width - 20, kLineViewHeight);
    maxY = CGRectGetMaxY(self.lineView.frame);
    
    for (int i = 0; i < self.unSelectedLabels.count; i++) {
        UILabel * label = self.unSelectedLabels[i];
        [self setupLabelFrameWithLabel:label index:i maxY:maxY width:labelWidth];
        if (i == self.unSelectedLabels.count - 1) {
            maxY = CGRectGetMaxY(label.frame);
        }
    }
}

#pragma mark - setups
- (void)setupLabelFrameWithLabel:(UILabel *)label index:(int)index maxY:(CGFloat)maxY width:(CGFloat)width {
    int row = index / kLabelColumn;
    int col = index % kLabelColumn;
    CGFloat labelX = kLabelMargin + col * (width + kLabelMargin);
    CGFloat labelY = maxY + kLabelMargin + row * (kLabelHeight + kLabelMargin);
    label.frame = CGRectMake(labelX, labelY, width, kLabelHeight);
}

- (void)setupLabels {
    
    for (NSString * tag in self.selectedTags) {
        UILabel * label = [self addLabelWithTitle:tag];
        label.backgroundColor = [UIColor cyanColor];
        [self.selectedLabels addObject:label];
    }
    
    for (NSString * tag in self.unselectedTags) {
        UILabel * label = [self addLabelWithTitle:tag];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.unSelectedLabels addObject:label];
    }
}

- (UILabel *)addLabelWithTitle:(NSString *)title {
    UILabel * label = [[UILabel alloc] init];
    [self addSubview:label];
    label.text = title;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.textColor = [UIColor blackColor];
    label.font = kLabelFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [label addGestureRecognizer:gr];
    return label;
}

#pragma mark - 点击事件
- (void)saveButtonClick {
    if ([self.delegate respondsToSelector:@selector(tagConfigView:saveTagChangeWithSelectedTags:)]) {
        NSMutableArray * tagArray = [[NSMutableArray alloc] init];
        for (UILabel * label in self.selectedLabels) {
            [tagArray addObject:label.text];
        }
        [self.delegate tagConfigView:self saveTagChangeWithSelectedTags:tagArray];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)labelClick:(UITapGestureRecognizer *)pgr {
    
    UILabel * label = (UILabel *)pgr.view;
    
    if ([self.selectedLabels indexOfObject:label] == NSNotFound) {
        [self.unSelectedLabels removeObject:label];
        [self.selectedLabels addObject:label];
        label.backgroundColor = [UIColor cyanColor];
    } else {
        [self.selectedLabels removeObject:label];
        [self.unSelectedLabels addObject:label];
        label.backgroundColor = [UIColor lightGrayColor];
    }
    
    _animFlg = YES;
    
    [self setNeedsLayout];
}

#pragma mark - getter
- (NSMutableArray *)selectedTags {
    if (!_selectedTags) {
        _selectedTags = [[NSMutableArray alloc] init];
    }
    return _selectedTags;
}

- (NSMutableArray *)unselectedTags {
    if (!_unselectedTags) {
        _unselectedTags = [[NSMutableArray alloc] init];
    }
    return _unselectedTags;
}

- (NSMutableArray *)selectedLabels {
    if (!_selectedLabels) {
        _selectedLabels = [[NSMutableArray alloc] init];
    }
    return _selectedLabels;
}

- (NSMutableArray *)unSelectedLabels {
    if (!_unSelectedLabels) {
        _unSelectedLabels = [[NSMutableArray alloc] init];
    }
    return _unSelectedLabels;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView * lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        _lineView = lineView;
        lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
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

@end
