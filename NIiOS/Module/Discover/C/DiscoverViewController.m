//
//  DiscoverViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PersonalCenterViewController.h"
#import "SaveViewController.h"

@interface DiscoverViewController ()
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) UITextField *textName;
@property(nonatomic,strong) UITextField *textPwd;
@property(nonatomic,strong) UIButton *btnRegist;
@property(nonatomic,strong) UIButton *btnLogin;

@property(nonatomic,strong) UIButton *btnSave;//数据存储开发指南
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.text = @"LeanCloud数据存储";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    self.labTitle = label;
    [self.view addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.height.equalTo(60);
    }];
    
    self.textName = [UITextField new];
    self.textName.placeholder = @"用户名";
    [self.textName setBorderStyle:UITextBorderStyleBezel];
    [self.textName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:self.textName];
    [self.textName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(40);
    }];
    
    self.textPwd = [UITextField new];
    self.textPwd.placeholder = @"密码";
    [self.textPwd setBorderStyle:UITextBorderStyleBezel];
    [self.textPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textPwd setSecureTextEntry:YES];
    [self.view addSubview:self.textPwd];
    [self.textPwd makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textName.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(40);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(button, 5.0);
    self.btnLogin = button;
    [self.view addSubview:self.btnLogin];
    [self.btnLogin makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textPwd.mas_left).offset(10);
        make.size.equalTo(CGSizeMake(kScreenWidth/3, 40));
        make.top.equalTo(self.textPwd.mas_bottom).offset(20);
    }];
    
    UIButton *buttonPwd = [[UIButton alloc] init];
    buttonPwd.backgroundColor = [UIColor redColor];
    buttonPwd.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [buttonPwd setTitle:@"注册" forState:UIControlStateNormal];
    [buttonPwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonPwd addTarget:self action:@selector(pwdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(buttonPwd, 5.0);
    self.btnRegist = buttonPwd;
    [self.view addSubview:self.btnRegist];
    [self.btnRegist makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textPwd.mas_right).offset(-10);
        make.size.equalTo(CGSizeMake(kScreenWidth/3, 40));
        make.top.equalTo(self.textPwd.mas_bottom).offset(20);
    }];
    
    UIButton *buttonSave = [[UIButton alloc] init];
    buttonSave.backgroundColor = [UIColor redColor];
    [buttonSave setTitle:@"数据存储开发指南*OC" forState:UIControlStateNormal];
    [buttonSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(goToSaveVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(buttonSave, 5.0);
    self.btnSave = buttonSave;
    [self.view addSubview:self.btnSave];
    [self.btnSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnRegist.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.8, 40));
    }];
    
    //记住用户名操作
    NSString* username = UserDefaultObjectForKey(@"username");
    if (![NSString isEmpty:username]) {
        self.textName.text = username;
        self.textPwd.text = @"123456";
    }
}
-(void)goToSaveVCWithBtn:(UIButton*)btn{
    SaveViewController* saveVC = [SaveViewController new];
    [self.navigationController pushViewController:saveVC animated:YES];
}
-(void)loginButtonClicked:(UIButton*)btn{
    NSString *username = self.textName.text;
    NSString *password = self.textPwd.text;
    if (username && password) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error){
            if (user) {
                //跳转页面
                //[UIApplication sharedApplication].keyWindow.rootViewController = [[LCTabBarController alloc]init];
                PersonalCenterViewController* pVC = [PersonalCenterViewController new];
                [self.navigationController pushViewController:pVC animated:YES];
                UserDefaultSetObjectForKey(username, @"username")
            } else {
                NSLog(@"登录失败：%@",error.localizedFailureReason);
                //登陆失败提醒
                [self.view makeToast:[NSString stringWithFormat:@"登陆失败:%@",error.localizedFailureReason] duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }
}
// LeanCloud - 注册 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash885156
-(void)pwdButtonClicked:(UIButton*)btn{
    AVUser *user = [AVUser user];
    user.username = self.textName.text;
    user.password = self.textPwd.text;
    /**
     //发送验证码短信 by:nixs 2019年03月13日09:19:09
     AVShortMessageRequestOptions* options = [AVShortMessageRequestOptions new];
     options.TTL = 10;
     options.type = AVShortMessageTypeText;
     options.signatureName = @"NIiOS";
     options.applicationName = @"敏捷开发模板";
     [AVSMS requestShortMessageForPhoneNumber:@"15001291877" options:options callback:^(BOOL succeeded, NSError * _Nullable error) {
     if (succeeded) {
     NSLog(@"短信发送成功");
     }else{
     NSLog(@"短信发送失败:%@",error.localizedFailureReason);
     }
     }];
     */
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功直接登录
            [AVUser logInWithUsernameInBackground:self.textName.text password:self.textPwd.text block:^(AVUser *user, NSError *error){
                if (user) {
                    //跳转页面
                    //[UIApplication sharedApplication].keyWindow.rootViewController = [[LCTabBarController alloc]init];
                    PersonalCenterViewController* pVC = [PersonalCenterViewController new];
                    [self.navigationController pushViewController:pVC animated:YES];
                } else {
                    NSLog(@"登录失败：%@",error.localizedFailureReason);
                    //登陆失败提醒
                    [self.view makeToast:[NSString stringWithFormat:@"登陆失败:%@",error.localizedFailureReason] duration:2.0 position:CSToastPositionCenter];
                }
            }];
        }else if(error.code == 202){
            //注册失败的原因可能有多种，常见的是用户名已经存在。
            NSLog(@"注册失败，用户名已经存在");
            [self.view makeToast:[NSString stringWithFormat:@"注册失败,用户名已存在"] duration:2.0 position:CSToastPositionCenter];
        }else{
            NSLog(@"注册失败：%@",error.localizedFailureReason);
            [self.view makeToast:[NSString stringWithFormat:@"注册失败:%@",error.localizedFailureReason] duration:2.0 position:CSToastPositionCenter];
        }
    }];
}
@end
