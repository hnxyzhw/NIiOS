//
//  NIBaseTableViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/20.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIBaseTableViewController.h"

@interface NIBaseTableViewController ()

@end

@implementation NIBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    #pragma mark - 所有Base视图背景色都是白色的
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)sayHello{
    NILog(@"===继承自NIBaseViewController后 NIBaseTableViewController里自定义方法.===");
}

@end
