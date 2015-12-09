//
//  ZTagController.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPagesView, ZPagesViewCell, ZTagController;

@protocol  ZTagControllerDataSource <NSObject>

- (ZPagesViewCell *)tagController:(ZTagController *)tagController pagesView:(ZPagesView *)pagesView cellAtIndex:(NSUInteger)index;

@end

@interface ZTagController : UIViewController

/** 标签 */
@property (nonatomic, strong) NSArray * tags;

/** 数据源 */
@property (nonatomic, weak) id<ZTagControllerDataSource> dataSource;

+ (instancetype)tagControllerWithRootVC:(UIViewController *)rootVC;

@end
