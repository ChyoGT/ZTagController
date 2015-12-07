//
//  ZPagesViewCell.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/4.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPagesViewCell : UIView
@property (nonatomic, copy) NSString * identifier;

+ (instancetype)pagesViewCellWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
@end
