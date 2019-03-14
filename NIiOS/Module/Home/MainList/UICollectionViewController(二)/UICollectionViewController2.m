//
//  UICollectionViewController2.m
//  NIiOS
//
//  Created by nixs on 2019/2/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "UICollectionViewController2.h"
#import "SelectedView.h"

@interface UICollectionViewController2 ()
@property(nonatomic,strong)UIButton* btn;
@property(nonatomic,strong) SelectedView* selectedView;
@property(nonatomic,strong) NSMutableArray *mulArray;
@end

@implementation UICollectionViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

/**
 自定义View打开与否 按钮 “选择” 与 “反选” 状态
 */
-(void)buttonClicked:(UIButton*)btn{
    //按钮状态取反
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        self.selectedView.hidden = NO;
    }else{
        self.selectedView.hidden = YES;
    }
}
/**
 UI初始化
 */
-(void)setupUI{
    self.navigationItem.title = @"UICollectionViewController(二)";
    //按钮
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"自定义View上是UICollectionView" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(button, 5)
    UIColor* colorBorder = [UIColor purpleColor];
    NIViewBorderRadius(button, 1, colorBorder.CGColor)
    self.btn = button;
    [self.view addSubview:self.btn];
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //自定义View里嵌套UICollectionView
    self.selectedView = [SelectedView new];
    [self.view addSubview:self.selectedView];
    [self.selectedView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.left.right.equalTo(self.view);
        make.height.equalTo(40*(3+2+1)+40*3+50);
    }];
    //期初自定义View处于隐藏状态；
    self.selectedView.hidden = YES;
    
    //模拟数据源赋值 by:nixs
    NSArray* array1= @[@"微信支付",@"支付宝",@"银联",@"POS",@"财付通",@"App扫码",@"手机扫码",@"POS扫码",@"银联刷卡"]; //40*3+40
    NSArray* array2= @[@"交易成功",@"交易失败",@"未支付",@"已关闭",@"处理中",@"支付异常",@"异常"];//40*2+40
    NSArray* array3= @[@"消费",@"退款",@"预授权"];//40+40
    self.mulArray = [NSMutableArray arrayWithObjects:array1,array2,array3,nil];
    self.selectedView.mulArray = self.mulArray;
    self.selectedView.titleArray = @[@"支付方式",@"交易状态",@"交易类型"];
}
/**
 数据源懒加载
 */
-(NSMutableArray *)mulArray{
    if (!_mulArray) {
        _mulArray = [NSMutableArray array];
    }
    return _mulArray;
}
@end
