
//
//  PlistViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/7.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//
//参考资料地址：https://www.jianshu.com/p/557574141a57

#import "PlistViewController.h"

@interface PlistViewController ()
@property(nonatomic,strong)UIButton* btnRead;

@property(nonatomic,strong)UIButton* btnRead2;
@end

@implementation PlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS plist文件操作,写入/删除/修改";
    self.btnRead = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 10, 200, 50)];
    self.btnRead.backgroundColor = [UIColor redColor];
    [self.btnRead setTitle:@"读取plist数据" forState:UIControlStateNormal];
    [self.btnRead addTarget:self action:@selector(btnReadClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewBorderRadius(self.btnRead, 1, [UIColor blackColor].CGColor)
    NIViewSetRadius(self.btnRead, 3)
    [self.view addSubview:self.btnRead];
    
    self.btnRead2 = [UIButton new];
    self.btnRead2.backgroundColor = [UIColor redColor];
    [self.btnRead2 setTitle:@"读取本地plist数据" forState:UIControlStateNormal];
    [self.view addSubview:self.btnRead2];
    [self.btnRead2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth-10);
        make.height.equalTo(50);
        make.top.equalTo(self.btnRead.mas_bottom).equalTo(10);
        make.centerX.equalTo(self.view);
    }];
    NIViewBorderRadius(self.btnRead2, 1, [UIColor blackColor].CGColor)
    NIViewSetRadius(self.btnRead2, 3)
    
    
    
}




-(void)btnReadClicked:(UIButton*)btnRead{
    NSString* filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/xiaoxi.plist"];
    NSMutableDictionary* dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"---plist一开始保存时候的内容---%@",dataDictionary);
}
-(void)writeData{
    //    //获取路径对象
    //    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString* path = [pathArray objectAtIndex:0];
    //    //获取文件的完整路径
    //    NSString* filePath = [path stringByAppendingString:@"xiaoxi.plist"];
    
    //上面3句话可以写成一句
    NSString* filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/xiaoxi.plist"];
    /**
     下面是我的plist路径,在桌面空白处点击一下，前往－按住option-资源库-Developer-CoreSimulator-Devices......就按照下面路径找到plist所在的位置
     /Users/baiteng01/Library/Developer/CoreSimulator/Devices/92444384-5241-4934-B078-1A7241F1B687/data/Containers/Data/Application/73005382-D1FB-4BC2-BB4E-1FBC64284141/Documents/xiaoxi.plist
     */
    //写入数据到plist文件
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小小虎",@"name",@"5",@"age",@"boy",@"sex",nil];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小小兮",@"name",@"6",@"age",@"girl",@"sex",nil];
    //将上面2个小字典保存到大字典里
    NSMutableDictionary* dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:dic1 forKeyedSubscript:@"stu1"];
    [dataDic setObject:dic2 forKeyedSubscript:@"stu2"];
    [dataDic writeToFile:filePath atomically:YES];
}


@end
