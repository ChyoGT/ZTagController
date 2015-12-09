//
//  ZTagController.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZTagController.h"
#import "ZTagsView.h"
#import "ZPagesView.h"
#import "ZPagesViewCell.h"
#import "ZTagConst.h"
#import "ZTagConfigView.h"

@interface ZTagController () <ZTagsViewDelegate, ZPagesViewDataSource, ZPagesViewDelegate, ZTagConfigViewDelegate>

@property (nonatomic, weak) ZTagsView * tagsView;
@property (nonatomic, weak) ZPagesView * pagesView;
@property (nonatomic, weak) ZTagConfigView * configView;

@property (nonatomic, strong) NSArray * tagArray;

@end

@implementation ZTagController

+ (instancetype)tagController {
    return [[self alloc] init];
}

+ (instancetype)tagControllerWithRootVC:(UIViewController *)rootVC {
    ZTagController * controller = [self tagController];
    [rootVC.view addSubview:controller.view];
    [rootVC addChildViewController:controller];
    return controller;
}

#pragma mark - 生命周期函数
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tagsView.frame = CGRectMake(0, 20, self.view.frame.size.width, ZTagViewHeight);
    self.pagesView.frame = CGRectMake(0, CGRectGetMaxY(self.tagsView.frame), self.view.frame.size.width
                                      , self.view.frame.size.height - self.tagsView.frame.size.height);
}

#pragma mark - setter
- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    NSMutableArray * tagArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < (tags.count > 6 ? 6 : tags.count); i++) {
        [tagArray addObject:tags[i]];
    }
    self.tagArray = tagArray;
    
    [self loadData];
}

- (void)loadData {
    self.tagsView.tags = self.tagArray;
    [self.pagesView reloadData];
}

#pragma mark - getter
- (ZTagsView *)tagsView {
    if (_tagsView == nil) {
        ZTagsView * tagsView = [ZTagsView tagsView];
        [self.view addSubview:tagsView];
        self.tagsView = tagsView;
        tagsView.tagDelegate = self;
    }
    return _tagsView;
}

- (ZPagesView *)pagesView {
    if (_pagesView == nil) {
        ZPagesView * pagesView = [ZPagesView pagesView];
        [self.view addSubview:pagesView];
        _pagesView = pagesView;
        pagesView.dataSource = self;
        pagesView.pageDelegate = self;
        pagesView.backgroundColor = [UIColor redColor];
        pagesView.pagingEnabled = YES;
    }
    return _pagesView;
}

- (ZTagConfigView *)configView {
    if (!_configView) {
        ZTagConfigView * configView = [ZTagConfigView tagConfigView];
        UIView * windowView = [UIApplication sharedApplication].keyWindow;
        [windowView addSubview:configView];
        _configView = configView;
        configView.delegate = self;
    }
    return _configView;
}

#pragma mark - ZTagsViewDelegate
- (void)tagsView:(ZTagsView *)tagsView tagDidSelected:(NSInteger)selectedIndex {
    [self.pagesView goToPageAtIndex:selectedIndex];
}

- (void)tagsViewSelectedTagDidClick:(ZTagsView *)tagsView {
    
}

- (void)tagsViewConfigButtonDidClick:(ZTagsView *)tagsView {
    [self.configView showTagConfigViewWithSelectedTags:self.tagArray tags:self.tags];
}

#pragma mark - ZPagesViewDataSource
- (NSUInteger)numberOfPagesInPageView:(ZPagesView *)pageView {
    return self.tagArray.count;
}

- (ZPagesViewCell *)pageView:(ZPagesView *)pageView cellAtIndex:(NSUInteger)index {
    
    ZPagesViewCell * cell = [pageView dequeueReusableCellWithIdentifier:ZPageReusableIdentifier];
    if (cell == nil) {
        
        if ([self.dataSource respondsToSelector:@selector(tagController:pagesView:cellAtIndex:)]) {
            cell = [self.dataSource tagController:self pagesView:pageView cellAtIndex:index];
        } else {
            cell = [[ZPagesViewCell alloc] initWithIdentifier:ZPageReusableIdentifier];
            cell.backgroundColor = ZRandomColor;
        }
    }
    return cell;
}

#pragma mark - ZPagesViewDelegate
- (void)pageView:(ZPagesView *)pageView viewDidChangeAtIndex:(NSUInteger)index {
    self.tagsView.currentTagIndex = index;
}

#pragma mark - ZTagConfigViewDelegate
- (void)tagConfigView:(ZTagConfigView *)tagConfigView saveTagChangeWithSelectedTags:(NSArray *)selectedTags {
    self.tagArray = selectedTags;
    [self loadData];
}

@end
