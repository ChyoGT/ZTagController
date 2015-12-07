//
//  ZPagesView.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPagesView, ZPagesViewCell;

@protocol ZPagesViewDataSource <NSObject>
@required
- (ZPagesViewCell *)pageView:(ZPagesView *)pageView cellAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfPagesInPageView:(ZPagesView *)pageView;
@end

@protocol ZPagesViewDelegate <NSObject>
@optional
- (void)pageView:(ZPagesView *)pageView viewDidChangeAtIndex:(NSUInteger)index;
@end

@interface ZPagesView : UIScrollView

@property (nonatomic, weak) id<ZPagesViewDataSource> dataSource;
@property (nonatomic, weak) id<ZPagesViewDelegate> pageDelegate;

+ (instancetype)pagesView;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

- (void)goToPageAtIndex:(NSUInteger)index;

@end
