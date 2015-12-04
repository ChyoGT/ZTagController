//
//  ZPagesView.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZPagesView.h"
#import "ZPagesViewCell.h"
#import "ZTagConst.h"

@interface ZPagesView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * cellFrames;

@property (nonatomic, strong) NSMutableSet * reusableCells;

@property (nonatomic, strong) NSMutableDictionary * displayingCells;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) NSUInteger numberOfCells;

@end

@implementation ZPagesView

#pragma mark - 构造函数
+ (instancetype)pagesView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - 生命周期函数
- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.cellFrames.count; i++) {
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        ZPagesViewCell * cell = self.displayingCells[@(i)];
        
        if ([self isInScreen:cellFrame]) {
            if (cell == nil) {
                cell = [self.dataSource pageView:self cellAtIndex:i];
                cell.frame = cellFrame;
                NSLog(@"%@", NSStringFromCGRect(cellFrame));
                [self addSubview:cell];
                
                self.displayingCells[@(i)] = cell;
            }
        } else {
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                [self.reusableCells addObject:cell];
            }
        }
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"frame"] && ![keyPath isEqualToString:@"contentSize"]) return;
    
    ZPagesView * pagesView = (ZPagesView *)object;
    if ([keyPath isEqualToString:@"frame"]) {
        self.contentSize = CGSizeMake(self.cellFrames.count * pagesView.frame.size.width, 0);
        
    } else if([keyPath isEqualToString:@"contentSize"]) {
        [self.cellFrames removeAllObjects];
        for (int i = 0; i < self.numberOfCells; i++) {
            CGRect cellFrame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
            [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableSet *)reusableCells {
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (NSMutableDictionary *)displayingCells {
    if (_displayingCells == nil) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}


- (NSMutableArray *)cellFrames {
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}



#pragma mark - 公共方法
- (void)goToPageAtIndex:(NSUInteger)index {
    if (self.cellFrames.count > index) {
        [self setContentOffset:CGPointMake(index * self.frame.size.width, 0)];
    }
}

- (void)reloadData {
    
    self.numberOfCells = [self.dataSource numberOfPagesInPageView:self];
    self.contentSize = CGSizeMake(self.numberOfCells * self.frame.size.width, 0);
}

#pragma mark - 私有方法
- (BOOL)isInScreen:(CGRect)frame {
    return (CGRectGetMaxX(frame) > self.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.contentOffset.x + self.bounds.size.width);
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    
    __block UIView * reusableCell = nil;
    
    [self.reusableCells enumerateObjectsUsingBlock:^(ZPagesViewCell * _Nonnull cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    if (self.currentPageIndex == index || index >= self.cellFrames.count || index < 0) return;
    
    self.currentPageIndex = index;
    if ([self.pageDelegate respondsToSelector:@selector(pageView:viewDidChangeAtIndex:)]) {
        [self.pageDelegate pageView:self viewDidChangeAtIndex:index];
    }
}

@end
