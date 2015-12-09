//
//  ViewController.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/2.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ViewController.h"
#import "ZTagController.h"
#import "ZPagesViewCell.h"
#import "ZPagesView.h"
#import "ZTagConst.h"


@interface ViewController () <ZTagControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray * tagArray = @[@"推荐", @"营养快线", @"哇哈哈", @"七喜", @"可口可乐", @"美年达", @"东方树叶", @"百事可乐", @"苹果", @"香蕉", @"梨", @"橘子", @"西红柿", @"西瓜", @"哈密瓜", @"火龙果", @"葡萄", @"石榴"];
    
    ZTagController * controller = [ZTagController tagControllerWithRootVC:self];
    controller.dataSource = self;
    controller.tags = tagArray;
}

#pragma mark - ZTagControllerDataSource
- (ZPagesViewCell *)tagController:(ZTagController *)tagController pagesView:(ZPagesView *)pagesView cellAtIndex:(NSUInteger)index {
    ZPagesViewCell * cell = [pagesView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [ZPagesViewCell pagesViewCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = ZRandomColor;
    return cell;
}

@end
