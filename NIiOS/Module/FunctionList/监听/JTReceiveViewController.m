

//
//  JTReceiveViewController.m
//  NIiOS
//
//  Created by nixs on 2019/1/31.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "JTReceiveViewController.h"

@interface JTReceiveViewController ()

@end

@implementation JTReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息发送页面";
    
    //某人发送了一个名为大新闻的通知，通知附带内容info
    //NSNotification *note = [NSNotification notificationWithName:@"大新闻" object:self userInfo:@{@"time":@"2019年01月31日11:04:23",@"desc":@"回家过年!!!"}];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil userInfo:@{@"time":@"2019年01月31日11:04:23",@"desc":@"回家过年!!!"}];
    [self.navigationController popViewControllerAnimated:NO];
}



@end
