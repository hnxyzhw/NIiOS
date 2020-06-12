//
//  JRStoreSetCountController.m
//  Pos
//
//  Created by 艾小新 on 2018/5/26.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import "JRStoreSetCountController.h"
#import "JRCountTextField.h"
#import "NSString+TextUtils.h"
// 浅灰
#define kGrayColor COLOR_WITH_HEX(0xf4f4f4)

@interface JRStoreSetCountController ()
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet JRCountTextField *countTF;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) JRStoreDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (nonatomic,assign) BOOL isHaveDian;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation JRStoreSetCountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置金额";
    self.view.backgroundColor = kGrayColor;
    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //viewDidLoad里获取焦点会引起布局问题
    [self.countTF becomeFirstResponder];
}

- (void)setupUI {
    //如下self.topView实际是不应该要的，这里走一遍也没事
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(margin);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(margin);
        }
    }];
    self.model = [JRStoreDetailModel new];
    //[self.countTF becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidchange:) name:UITextFieldTextDidChangeNotification object:self.countTF];
    
    self.certainBtn.layer.cornerRadius = 5.0;
    [self.certainBtn.layer masksToBounds];
    self.certainBtn.userInteractionEnabled = NO;
    
    // 遮罩View
    self.bgView = [UIView new];
    self.bgView.alpha = 0.6;
    [self.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UITapGestureRecognizer *bgGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [self.bgView addGestureRecognizer:bgGes];
    [self.view addGestureRecognizer:bgGes];
 
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - KVO
- (void)textFieldTextDidchange:(NSNotification *)notification {
    UITextField *fd = notification.object;
    NSLog(@"===店铺二维码输入金额:%@===",fd.text);
    if (![NSString isEmpty:fd.text]) {//输入金额非空
        double countTF = [fd.text doubleValue];
        if (countTF>=999999999) {//店铺二维码设置金额>999 999 999
            self.certainBtn.userInteractionEnabled = NO;
            [self.certainBtn setBackgroundColor:kRedGrayColor];
            //店铺二维码设置金额不能大于￥999,999,999.
            [self.view makeToast:@"金额超限!" duration:2.0 position:CSToastPositionCenter];
            // do something.(用户要去修改金额)
        }else if(countTF<=0){//金额<=0不允许 确定按钮能用
            self.certainBtn.userInteractionEnabled = NO;
            [self.certainBtn setBackgroundColor:kRedGrayColor];
        }else{
            self.certainBtn.userInteractionEnabled = YES;
            [self.certainBtn setBackgroundColor:kRedColor];
        }
    }else{
        self.certainBtn.userInteractionEnabled = NO;
        [self.certainBtn setBackgroundColor:kRedGrayColor];
    }
}

- (IBAction)certainBtnClick:(id)sender {
    // 为金额添加金钱标示，千分符
    NSString *bridge = [NSString positiveFormat:self.countTF.text];
    NSString *final = [NSString stringWithFormat:@"￥%@",bridge];
    _model.count = final;
    // 返回上一级，并且传值
    if (self.countBlock) {
        self.countBlock(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 遮罩点击
- (void)bgClick {
    self.bgView.hidden = YES;
    [self.view endEditing:YES];
}

#pragma mark - JRStoreCountInfoViewDelegate
// 确定
-(void)storeCountInfoViewLoginClick:(NSString *)infoStr {
    [self bgClick];
}

// 取消
-(void)storeCountInfoViewCancelClick {
    [self bgClick];
}

@end
