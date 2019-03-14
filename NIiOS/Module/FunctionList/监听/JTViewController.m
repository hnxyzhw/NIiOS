//
//  JTViewController.m
//  NIiOS
//
//  Created by nixs on 2019/1/31.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "JTViewController.h"
#import "JTReceiveViewController.h"
#import "StudentHN.h"//学生HN对象

@interface JTViewController ()
@property(nonatomic,strong) UIButton *btnJTReceive;//接收页控制器
@property(nonatomic,strong) UITextField *textField;//输入框
@property(nonatomic,strong) UIButton *btnListen;//监听模型属性值的改变
@property(nonatomic,strong) StudentHN* stu;
@end

@implementation JTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS监听";
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyBoardWillShowWithNotification:(NSNotification*)notification{
    DLog(@"==keyBoardWillShowWithNotification:%@===",notification.userInfo);
    [self.view makeToast:[NSString stringWithFormat:@"time:%@-desc:%@",notification.userInfo[@"time"],notification.userInfo[@"desc"]] duration:3.0 position:CSToastPositionTop];
}
-(void)setupUI{
    //按钮
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"消息接收页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnJTReceive = button;
    NIViewSetRadius(self.btnJTReceive, 5)
    NIViewBorderRadius(self.btnJTReceive, 1, [UIColor blueColor].CGColor)
    [self.view addSubview:self.btnJTReceive];
    [self.btnJTReceive makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.height.equalTo(50);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    //输入框
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.placeholder = @"请输入姓名";
    [self.view addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnJTReceive.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.btnJTReceive);
    }];
    //btn 使对象属性发生变化
    UIButton *button2 = [[UIButton alloc] init];
    button2.backgroundColor = [UIColor redColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 setTitle:@"btn 使对象属性发生变化" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeValueOfStudentHN:) forControlEvents:UIControlEventTouchUpInside];
    self.btnListen = button2;
    NIViewSetRadius(self.btnListen, 5)
    NIViewBorderRadius(self.btnListen, 1, [UIColor purpleColor].CGColor)
    [self.view addSubview:self.btnListen];
    [self.btnListen makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.height.equalTo(50);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    //对象赋值
    self.stu = [StudentHN new];
    self.stu.name = @"nixs";
    self.stu.sex = @"male";
    //self.stu.age = [@"28" integerValue];
    DLog(@"===self.stu.name:%@==",self.stu.name);
    [self.stu setValue:@"nixinsheng" forKey:@"name"];
    DLog(@"===【KVC 赋值】self.stu.name:%@==",self.stu.name);
    [self.stu addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.stu addObserver:self forKeyPath:@"sex" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO监听方法（常用作用:监听模型属性值的改变）
//self得实现监听方法
/**
 *当监听到object的keyPath属性发生了改变
 */
//这个方法继承于NSObject，所以不需要遵守其他协议，任何对象都可以调用这个方法
//改变了object的哪个值(KeyPath),改成了什么(字典change)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"------监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
}
//重新改变stu值
-(void)changeValueOfStudentHN:(UIButton*)btn{
    self.stu.name = @"hanlu";
    self.stu.sex = @"female";
    //self.stu.age = [@"27" integerValue];
}
-(void)buttonClicked:(UIButton*)btn{
    JTReceiveViewController* jtRVC = [JTReceiveViewController new];
    [self.navigationController pushViewController:jtRVC animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.stu removeObserver:self forKeyPath:@"name"];
    [self.stu removeObserver:self forKeyPath:@"sex" context:nil];
}
@end
