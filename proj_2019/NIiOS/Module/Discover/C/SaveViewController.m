


//
//  SaveViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()
@property(nonatomic,strong) UILabel *labDesc;
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"数据存储开发指南 · Objective-C * LeanStorage";
    [self setupUI];
    [self saveTodo];
    //[self saveObj];
}

/**
 AVObject 支持的数据类型
 */
-(void)saveObj{
    NSNumber* boolean=@(YES);
    NSNumber* number = [NSNumber numberWithInt:2019];
    NSString* string = [NSString stringWithFormat:@"%@年度音乐排行",number];
    NSDate* date = [NSDate date];
    NSData* data = [@"短篇小说" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* array = [NSArray arrayWithObjects:string,number, nil];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:number,@"数字",string,@"字符串", nil];
    
    AVObject* object = [AVObject objectWithClassName:@"DataTypes"];
    [object setObject:boolean forKey:@"testBoolean"];
    [object setObject:number forKey:@"testInteger"];
    [object setObject:string forKey:@"testString"];
    [object setObject:date forKey:@"testDate"];
    [object setObject:data forKey:@"testData"];
    [object setObject:array forKey:@"testArray"];
    [object setObject:dictionary forKey:@"testDictionary"];
    WEAKSELF;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSString* message = [NSString stringWithFormat:@"存储成功:objectId[%@]",object.objectId];
            NSLog(@"---message:%@",message);
            [weakSelf.view makeToast:message duration:1.0 position:CSToastPositionCenter];
        }else{
            [weakSelf.view makeToast:@"失败的话，请检查网络环境以及 SDK 配置是否正确" duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    AVObject *todoFolder = [[AVObject alloc] initWithClassName:@"TodoFolder"];// 构建对象
    [todoFolder setObject:@"工作" forKey:@"name"];// 设置名称
    [todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
    [todoFolder saveInBackground];// 保存到云端
    
    // 执行 CQL 语句实现新增一个 TodoFolder 对象
    [AVQuery doCloudQueryInBackgroundWithCQL:@"insert into TodoFolder(name, priority) values('工作啦啦啦😋', 2) " callback:^(AVCloudQueryResult *result, NSError *error) {
        // 如果 error 为空，说明保存成功
        [weakSelf.view makeToast:[NSString stringWithFormat:@"执行 CQL 语句实现新增一个 TodoFolder 对象-保存成功:%@",error.localizedFailureReason] duration:1.0 position:CSToastPositionCenter];
    }];
}

/**
 0.setupUI
 */
-(void)setupUI{
    self.labDesc = [UILabel new];
    self.labDesc.numberOfLines = 0;
    self.labDesc.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    self.labDesc.text = @"1.我们为各个平台或者语言开发的 SDK 在底层都是通过 HTTPS 协议调用统一的 REST API，提供完整的接口对数据进行各类操作。LeanStorage 在结构化数据存储方面，与 MySQL、Postgres、MongoDB 等数据库的区别在于：+数据库是面向服务器端的，用户自己开发的服务器端程序以用户名和密码登录到数据库。用户需要在服务器端程序里自己实现应用层的权限管理并向客户端提供接口。LeanStorage 是面向客户端的存储服务，通过 ACL 机制在 API 层面提供了完整的权限管理功能。很多开发者都选择通过在客户端集成 LeanStorage SDK 来直接访问数据，而不再开发服务端的程序。\n\n2.与关系型数据库（MySQL、Postgres等）相比，LeanStorage 对多表查询（join）和事务等功能的支持较弱，所以在有些应用场景中会需要以有一定冗余的方式存储数据，以此换来的是良好的可扩展性，更有利于支撑起大流量的互联网应用。\n\n下面我们逐一介绍 LeanStorage 支持的两类数据：+对象/文件";
}
/**
 1.创建Todo类型的对象，并将它c
 */
-(void)saveTodo{
    AVObject* todo = [AVObject objectWithClassName:@"Todo"];
    [todo setObject:@"工程师周会" forKey:@"title"];
    [todo setObject:@"每周工程师会议,周一下午2点" forKey:@"content"];
    [todo setObject:@"会议室" forKey:@"location"];//只要添加这一行代码,云端就会自动添加这个字段
    WEAKSELF;
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSString* message = [NSString stringWithFormat:@"存储成功:objectId[%@]",todo.objectId];
            NSLog(@"---message:%@",message);
            [weakSelf.view makeToast:@"存储成功" duration:1.0 position:CSToastPositionCenter];
        }else{
            [weakSelf.view makeToast:@"失败的话，请检查网络环境以及 SDK 配置是否正确" duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    AVObject* theTodo = [AVObject objectWithClassName:@"Todo" objectId:@"5c8f82118d6d81007002cb03"];
    [theTodo fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSString* content=[object objectForKey:@"content"];
        NSString* title = [object objectForKey:@"title"];
        NSString* location = [object objectForKey:@"location"];
        NSLog(@"todo---%@-%@-%@",title,content,location);
        
        //获取三个特殊属性
        NSString* objectId = theTodo.objectId;
        NSDate* updateAt = theTodo.updatedAt;
        NSDate* createAt = theTodo.createdAt;
        //NSDate* createAt = [obj objectForKey:@"createdAt"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"---获取三个特殊属性:objectId:%@-updateAt:%@/createAt:%@,",objectId,[dateFormatter stringFromDate:createAt],[dateFormatter stringFromDate:updateAt]);
    }];
    
    AVFile *file = [AVFile fileWithRemoteURL:[NSURL URLWithString: @"http://ww3.sinaimg.cn/bmiddle/596b0666gw1ed70eavm5tg20bq06m7wi.gif"]];
    AVObject *todo2 = [AVObject objectWithClassName:@"Todo"];
    [todo2 setObject:file forKey:@"girl"];
    [todo2 setObject:@"明星" forKey:@"topic"];
    [todo2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        AVQuery *query = [AVQuery queryWithClassName:@"Todo"];
        [query whereKey:@"topic" equalTo:@"明星"];
        [query includeKey:@"girl"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            AVObject *todo = objects[0];
            AVFile *file = [todo objectForKey:@"girl"];
            NSString *url = file.url;
            NSLog(@"------URL:%@",url);
        }];
    }];
    
}

@end
