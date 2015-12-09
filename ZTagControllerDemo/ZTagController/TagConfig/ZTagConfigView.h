//
//  ZTagConfigView.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/8.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTagConfigView;

@protocol ZTagConfigViewDelegate <NSObject>
- (void)tagConfigView:(ZTagConfigView *)tagConfigView saveTagChangeWithSelectedTags:(NSArray *)selectedTags;
@end

@interface ZTagConfigView : UIView

@property (nonatomic, weak) id<ZTagConfigViewDelegate> delegate;

+ (instancetype)tagConfigView;

- (void)showTagConfigViewWithSelectedTags:(NSArray *)selectedArray tags:(NSArray *)tags;

@end
