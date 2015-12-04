//
//  ZTagConst.h
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/2.
//  Copyright © 2015年 yd. All rights reserved.
//

#ifndef ZTagConst_h
#define ZTagConst_h



#define ZTagButtonWidth 80
#define ZTagButtonHeight 40
#define ZTagButtonMargin 10
#define ZTagButtonFontNormal [UIFont systemFontOfSize:14]
#define ZTagButtonFontSelected [UIFont systemFontOfSize:15]
#define ZTagButtonColorNormal [UIColor blackColor]
#define ZTagButtonColorSelected [UIColor redColor]

#define ZTagViewHeight ZTagButtonHeight

#define ZPageTransitionType @"cube"
#define ZPageTransitionDuration 1

#define ZPageReusableIdentifier @"viewId"
#define ZPageDefaultPageNumber 3

#define ZRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1]

#endif /* ZTagConst_h */
