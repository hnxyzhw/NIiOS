
//
//  ModelViewController.m
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "ModelViewController.h"
#import "ModelForVC.h"

@interface ModelViewController ()

@end

@implementation ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //modelVC
    self.navigationItem.title = @"MJExtension数据模型赋值注意问题";
    //ModelForVC* model = [ModelForVC modelWithJSON:@"{\"name\":\"nixs\",\"age\":28,\"sex\":\"male\",\"schoolName\":\"\"}"];
    ModelForVC* model = [ModelForVC modelWithJSON:@"{\"name\":\"nixs\",\"age\":28,\"sex\":\"male\"}"];
    DLog(@"---name:%@",model.name);
    DLog(@"---age:%ld",model.age);
    DLog(@"---schoolName:%@",model.schoolName);
}

/**
数据源json串
 */
-(NSDictionary*)dicFromJsonStr{
    NSDictionary *dic = [NSString NIDictionaryFromJSONFileName:@"modelJson.json"];
    return dic;
}

@end
