//
//  ZPagesViewCell.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/4.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ZPagesViewCell.h"

@implementation ZPagesViewCell

+ (instancetype)pagesViewCellWithIdentifier:(NSString *)identifier {
    return [[self alloc] initWithIdentifier:identifier];
}
- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

@end
