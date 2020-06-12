//
//  QRCodeViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIImage+BarOrQRCode.h"//条码 or 二维码
#import "UILabel+JRLabel.h"
#import "JRStoreSetCountController.h"//设置金额
#import "JRStoreDetailModel.h"
#import "NSString+TextUtils.h"
#import "JRDESTool.h"

@interface QRCodeViewController ()
@property(nonatomic,strong)UILabel* labTitle;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIView* headView;
@property(nonatomic,strong)UIButton* btnWX;
@property(nonatomic,strong)UIButton* btnZhiFuBao;

@property(nonatomic,strong)UILabel* labPayAttention;//支付提醒（扫码付款）
@property(nonatomic,strong)UILabel* labPayCount;//收款金额

@property(nonatomic,strong)UIView* centerView;//承载二维码
@property(nonatomic,strong)UIImageView* qrImgView;//二维码

@property(nonatomic,strong)UILabel* labUser;//客户名称

@property(nonatomic,strong)UIView* footerView;

@property(nonatomic,strong)UILabel* labSave;//保存到相册
@property(nonatomic,strong)UILabel* labSetCount;//设置金额

@property (nonatomic,strong) JRStoreDetailModel *model;
@end

@implementation QRCodeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景颜色
    //UIImage *img = [UIImage getImageWithColor:[UIColor redColor]];
    UIImage *img = [UIImage getImageWithColor:kThemeColor];
    [self.navigationController.navigationBar setBackgroundImage:img  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //设置导航栏背景颜色
    UIImage *img = [UIImage getImageWithColor:kThemeColor];
    [self.navigationController.navigationBar setBackgroundImage:img  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺二维码";
    self.view.backgroundColor = [UIColor redColor];
    [self setupUI];
}
-(void)setupUI{
    CGFloat contentHeaderH = 60;
    CGFloat contentFootH = 60;
    CGFloat W_H = kScreenWidth-12*margin;
    CGFloat fontPayCount = 30;
    CGFloat fontHeader = 12;
    
    CGFloat content_W = kScreenWidth - 2*margin*2;
    
    if (IS_IPHONE5||IS_IPHONE6) {
        contentHeaderH = 55;
        contentFootH = 50;
        W_H = kScreenWidth-13*margin;
        fontPayCount = 30;
        fontHeader = 10;
    }
    
    self.labTitle = [UILabel new];
    self.labTitle.text = @"收款二维码可打印张贴到门店中";
    self.labTitle.textAlignment = NSTextAlignmentCenter;
    self.labTitle.textColor = [UIColor whiteColor];
    [self.labTitle setFont:NIUIFontSize(15)];
    //self.labTitle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        }else{
            make.top.equalTo(self.view.mas_topMargin).offset(10);
        }
    }];
    //有点透明的黑色遮罩底部View
    self.bgView = [UIView new];
    self.bgView.backgroundColor = COLOR_WITH_HEX(0xd32834);
    NIViewSetRadius(self.bgView, 8.0);
    [self.view addSubview:self.bgView];
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(30);
        make.trailing.equalTo(self.view).offset(-30);
        // 加上这个 update失效了。约束不一定要一开始就加满
        // make.bottom.equalTo(-3*kCellMargin);
    }];
    //上方(微信支付、支付宝支付)两个图片底部承载
    self.headView = [UIView new];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bgView);
        make.height.equalTo(contentHeaderH);
    }];
    //微信、支付宝
    self.btnWX = [UIButton new];
    [self.btnWX setTitle:@"微信支付" forState:UIControlStateNormal];
    [self.btnWX.titleLabel setFont:NIUIFontSize(15)];
    [self.btnWX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnWX setImage:[UIImage imageNamed:@"d_wechat"] forState:UIControlStateNormal];
    [self.headView addSubview:self.btnWX];
    [self.btnWX makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(self.headView);
        make.centerX.equalTo(self.headView).offset(-contentHeaderH);
        make.centerY.equalTo(self.headView);
    }];
    [UIButton setImageUpDownTitle:self.btnWX];
    
    self.btnZhiFuBao = [UIButton new];
    [self.btnZhiFuBao.titleLabel setFont:NIUIFontSize(15)];
    [self.btnZhiFuBao setTitle:@"支付宝" forState:UIControlStateNormal];
    [self.btnZhiFuBao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnZhiFuBao setImage:[UIImage imageNamed:@"d_zfb"] forState:UIControlStateNormal];
    [self.headView addSubview:self.btnZhiFuBao];
    [self.btnZhiFuBao makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(self.headView);
        make.centerX.equalTo(self.headView).offset(contentHeaderH);
        make.centerY.equalTo(self.headView);
    }];
    [UIButton setImageUpDownTitle:self.btnZhiFuBao];
    //扫码付款提示内容
    self.labPayAttention = [UILabel new];
    self.labPayAttention.text = @"扫码付款";
    self.labPayCount.font = [UIFont systemFontOfSize:13];
    self.labPayAttention.textAlignment = NSTextAlignmentCenter;
    self.labPayAttention.textColor = [UIColor whiteColor];
    [self.bgView addSubview:self.labPayAttention];
    [self.labPayAttention makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.bgView);
    }];
    //扫码金额
    self.labPayCount = [UILabel new];
    self.labPayCount.text = @"";
    self.labPayCount.numberOfLines = 1;
    self.labPayCount.font = [UIFont systemFontOfSize:fontPayCount];
    self.labPayCount.textAlignment = NSTextAlignmentCenter;
    self.labPayCount.textColor = [UIColor whiteColor];
    //UILabel宽度固定, 字体大小自适应
    self.labPayCount.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:self.labPayCount];
    [self.labPayCount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labPayAttention.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.bgView);
    }];
    //承载二维码自定义View
    self.centerView = [UIView new];
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.centerView];
    [self.centerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labPayCount.mas_bottom).offset(5);
        make.centerX.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(W_H,W_H));
    }];
    //二维码 init
    NSString *codeStr = @"http://totalpay.test.bank.ecitic.com/totalpay/getCode.do?codeid=29ed8a330efde79e020875d4bb5bd3bd";
    //self.qrImgView = [[UIImageView alloc] initWithImage:[UIImage imageForCodeString:codeStr size:250 color:[UIColor blackColor] pattern:kCodePatternForQRCode]];
    self.qrImgView = [[UIImageView alloc] initWithImage:[UIImage qrImageForString:codeStr imageSize:250 logoImageSize:50]];
    [self.centerView addSubview:self.qrImgView];
    [self.qrImgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.centerView);
        make.size.equalTo(CGSizeMake(W_H-35,W_H-35));
    }];
    //客户名称
    self.labUser = [UILabel new];
    self.labUser.text = @"倪新生";
    self.labUser.textAlignment = NSTextAlignmentCenter;
    self.labUser.textColor = [UIColor whiteColor];
    [self.bgView addSubview:self.labUser];
    [self.labUser makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.bgView);
    }];
    //下方保存到相册 设置/清理金额
    self.footerView = [UIView new];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.footerView];
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.bgView);
        CGFloat offsetH = 10;
        if (IS_IPHONE5||IS_IPHONE6) {
            offsetH = 0.5*10;
        }
        make.top.equalTo(self.labUser.mas_bottom).offset(offsetH);
        make.height.equalTo(contentFootH);
    }];

    self.labSave = [UILabel labelWithFontSize:18.0 title:@"保存至相册" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.footerView addSubview:self.labSave];
    self.labSetCount = [UILabel labelWithFontSize:18.0 title:@"设置金额" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.footerView addSubview:self.labSetCount];

    [self.labSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView);
        make.leading.equalTo(self.footerView);
        make.width.equalTo(content_W/2-1);
        make.height.equalTo(contentHeaderH);
    }];
    UITapGestureRecognizer *saveGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveClick)];
    [self.labSave addGestureRecognizer:saveGes];
    self.labSave.userInteractionEnabled = YES;

    [self.labSetCount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView);
        make.trailing.equalTo(self.footerView);
        make.width.equalTo(content_W/2-1);
        make.height.equalTo(contentHeaderH);
    }];
    UITapGestureRecognizer *setCountGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCountClick)];
    [self.labSetCount addGestureRecognizer:setCountGes];
    self.labSetCount.userInteractionEnabled = YES;

    // 按钮中央竖线
    UIView *lView = [UIView new];
    lView.backgroundColor = COLOR_WITH_HEX(0xb6b6b6);
    [self.footerView addSubview:lView];
    [lView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.footerView);
        make.top.equalTo(10);
        make.bottom.equalTo(-10);
        make.width.equalTo(1);
    }];
    
    // 修改(update操作-盒模型底层view高度是被撑大的)最终containerView的高度
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerView.mas_bottom);
    }];
}
#pragma mark - 按钮监听
// 保存相册
- (void)saveClick {
    NSLog(@"保存到相册");
    //self.containerView
    UIImageWriteToSavedPhotosAlbum([self UIViewToUIImageView:self.bgView], self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (UIImage*)UIViewToUIImageView:(UIView*)view{
    //也就是底部两个按钮的高度
    CGFloat Delt = 60.0;
    if (IS_IPHONE5||IS_IPHONE6) {
        Delt = 50.0;
    }
    CGSize size = CGSizeMake(self.bgView.frame.size.width,self.bgView.frame.size.height-Delt);
    // 下面的方法：第一个参数表示区域大小；第二个参数表示是否是非透明的如果需要显示半透明效果，需要传NO，否则传YES；第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
// 保存相册回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
}

// 设置金额
- (void)setCountClick {
    if ([self.labSetCount.text isEqualToString:@"设置金额"]) {
        WEAKSELF;
        JRStoreSetCountController *controller = [[JRStoreSetCountController alloc] init];
        controller.countBlock = ^(JRStoreDetailModel *model) {
            weakSelf.model = model;
            // 设置扫码付款下面新增金额 和 明细View
            [weakSelf setNewView:NO];
        };
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        // 清除金额
        [self setNewView:YES];
    }
}

// 设置金额后
- (void)setNewView:(Boolean)isclear {
    if (isclear) {
        // 删除金额
        self.labSetCount.text = @"设置金额";
        
        self.labPayCount.text = @"";
        [self.labPayCount updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        NSString *codeStr = @"http://totalpay.test.bank.ecitic.com/totalpay/getCode.do?codeid=29ed8a330efde79e020875d4bb5bd3bd_nixs";
        // 刷新页面
        //self.qrImgView.image = [UIImage imageForCodeString:codeStr size:250 color:[UIColor blackColor] pattern:kCodePatternForQRCode];
        self.qrImgView.image = [UIImage qrImageForString:codeStr imageSize:250 logoImageSize:50];
    }else{
        // 展示金额，刷新二维码
        self.labSetCount.text = @"清除金额";
        
        self.labPayCount.text = self.model.count;
        [self.labPayCount updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(200, 30));
            //make.top.equalTo(self.labPayAttention.mas_bottom).offset(5);
            //make.leading.trailing.equalTo(self.bgView);
        }];
        NSString *codeStr = @"http://totalpay.test.bank.ecitic.com/totalpay/getCode.do?codeid=29ed8a330efde79e020875d4bb5bd3bd_nixs";
        NSString *cashString = [NSString pureFloatString:self.model.count];
        NSString *codeString = [NSString stringWithFormat:@"%@&money=%@",codeStr,[JRDESTool encryptUseDES:cashString key:desKey]];
        //外网测试 by:nixs 2018年09月25日10:14:53 通过(订单号ORDERNO是接口这边生成的)
        //NSString *codeString = [NSString stringWithFormat:@"http://totalpay.test.bank.ecitic.com/totalpay/getCode.do?codeid=29ed8a330efde79e020875d4bb5bd2be&money=%@&ORDERNO=20180723090001",[JRDESTool encryptUseDES:cashString key:desKey]];
        //添加加密后金额后的二维码~http://totalpay.test.bank.ecitic.com/totalpay/getCode.do?codeid=29ed8a330efde79e020875d4bb5bd2be&money=8MbLou/hXHw=&ORDERNO=20180723090001
        //添加金额后的二维码~https://totalpay.citicbank.com/totalpay/getCode.do?codeid=ddecba895d21790fea9c8c2529b91936&money=55.00
        NSLog(@"添加金额后的二维码~%@",codeString);
        // 刷新页面
        //self.qrImgView.image = [UIImage imageForCodeString:codeString size:250 color:[UIColor blackColor] pattern:kCodePatternForQRCode];
        self.qrImgView.image = [UIImage qrImageForString:codeString imageSize:250 logoImageSize:50];
    }
    // 修改(update操作-盒模型底层view高度是被撑大的)最终containerView的高度
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerView.mas_bottom);
    }];
}


@end
