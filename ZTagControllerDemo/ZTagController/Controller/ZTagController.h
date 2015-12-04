//
//  ZTagController.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/3.
//  Copyright © 2015年 yd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTagController : UIViewController

@property (nonatomic, strong) NSArray * tags;

+ (instancetype)tagControllerWithRootVC:(UIViewController *)rootVC;

@end
