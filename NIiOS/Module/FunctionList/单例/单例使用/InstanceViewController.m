//
//  InstanceViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

/**
 参考链接：https://www.jianshu.com/p/b207a92bf45b?utm_campaign=hugo&utm_medium=reader_share&utm_content=note&utm_source=weixin-friends
 */

#import "InstanceViewController.h"
#import "StuTools.h"
#import "Rabbit.h"

@interface InstanceViewController ()

@end

@implementation InstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"单例";
    NSString* message = [NSString stringWithFormat:@"name:%@,sex:%@,age:%ld,no:%@",[StuTools sharedInstance].stuModel.name,[StuTools sharedInstance].stuModel.sex,(long)[StuTools sharedInstance].stuModel.age,[StuTools sharedInstance].stuModel.no];
    [self.view makeToast:message duration:3.0 position:CSToastPositionCenter];
    
    
    
    [self.view makeToast:[Rabbit sharedInstance].nameOfRabbit duration:3.0 position:CSToastPositionBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
