//
//  ZTagsView.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTagsView;

@protocol ZTagsViewDelegate <NSObject>

@optional
- (void)tagsView:(ZTagsView *)tagsView tagDidSelected:(NSInteger)selectedIndex;
- (void)tagsViewSelectedTagDidClick:(ZTagsView *)tagsScrollView;

@end

@interface ZTagsView : UIView

@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, assign) NSInteger currentTagIndex;
@property (nonatomic, weak) id<ZTagsViewDelegate> tagDelegate;

+ (instancetype)tagsView;

@end
