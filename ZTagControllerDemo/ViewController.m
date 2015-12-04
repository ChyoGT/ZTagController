//
//  ViewController.m
//  ZTagControllerDemo
//
//  Created by 张彦东 on 15/12/2.
//  Copyright © 2015年 yd. All rights reserved.
//

#import "ViewController.h"
#import "ZTagController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray * tagArray = @[@"推荐", @"营养快线", @"哇哈哈", @"七喜", @"可口可乐", @"美年达", @"东方树叶", @"..."];
    
    ZTagController * controller = [ZTagController tagControllerWithRootVC:self];
    controller.tags = tagArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
