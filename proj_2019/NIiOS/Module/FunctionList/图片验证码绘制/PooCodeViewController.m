
//
//  PooCodeViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/7.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "PooCodeViewController.h"
#import "PooCodeView.h"

@interface PooCodeViewController ()
@property(nonatomic,strong)PooCodeView* pooCodeView;//验证码
@end

@implementation PooCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS 生成图片验证码绘制实例代码";
    //self.pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(10, kNavbarHeight+10, 80, 30)];
    //self.pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth/4, 50)];
    
    self.pooCodeView = [[PooCodeView alloc] init];
    //以后这样定位一个自定义View的话，先给出Size，再给出Point(注:Point是该自定义View的中心坐标)
    [self.pooCodeView setSize:CGSizeMake(100, 50)];
    [self.pooCodeView setCenter:CGPointMake(kScreenWidth/2, 25+10)];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.pooCodeView addGestureRecognizer:tap];
    [self.view addSubview:self.pooCodeView];
    NSLog(@"===验证码初始化的值:changeString:%@===",self.pooCodeView.changeString);
    [self.view makeToast:self.pooCodeView.changeString duration:3.0 position:CSToastPositionCenter];
    
    //block回调改变后随机码值
    WEAKSELF;
    [self.pooCodeView setChangeCodeBlock:^(NSString *codeStr) {
        NSLog(@"===触摸回调的值:codeStr:%@===",codeStr);
        [weakSelf.view makeToast:codeStr duration:3.0 position:CSToastPositionCenter];
    }];
}
-(void)tapClick{
    [self.pooCodeView changeCode];
    NSLog(@"===一直都会有的属性值:changeString:%@===",self.pooCodeView.changeString);
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
