//
//  NIVersionManagerView.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIVersionManagerView.h"

@implementation NIVersionManagerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth*0.8);
        make.center.equalTo(self);
    }];
    [self.bgView.layer setCornerRadius:5];
    
    self.labTitle = [UILabel new];
    self.labTitle.text = @"温馨提示";
    self.labTitle.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.equalTo(30);
        make.top.equalTo(self.bgView.mas_top).equalTo(5);
    }];
    
    self.labDesc = [UILabel new];
    self.labDesc.text = @"本次版本更新内容如下:";
    self.labDesc.textAlignment = NSTextAlignmentCenter;
    self.labDesc.textColor = [UIColor grayColor];
    self.labDesc.numberOfLines = 0;
    [self.bgView addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.labTitle.mas_bottom).equalTo(5);
    }];
    
    self.btnExit = [UIButton new];
    [self.btnExit setTitle:@"退出" forState:UIControlStateNormal];
    [self.btnExit setBackgroundColor:[UIColor grayColor]];
    [self.btnExit addTarget:self action:@selector(btnExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnExit];
    [self.btnExit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labDesc.mas_bottom).offset(20);
        make.left.equalTo(self.bgView).offset(20);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    [self.btnExit.layer setCornerRadius:5];
    
    self.btnOK = [UIButton new];
    [self.btnOK setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.btnOK setBackgroundColor:[UIColor redColor]];
    [self.btnOK addTarget:self action:@selector(btnOKClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnOK];
    [self.btnOK makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labDesc.mas_bottom).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    [self.btnOK.layer setCornerRadius:5];
    
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnOK.mas_bottom).equalTo(20);
    }];
}
-(void)btnExitClicked:(UIButton*)btn{
    if (self.btnExitBlock) {
        self.btnExitBlock();
    }
}
-(void)btnOKClicked:(UIButton*)btn{
    if(self.btnOKBlock){
        self.btnOKBlock();
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.labTitle.text = _title.length>0?self.title:@"温馨提示";
}
-(void)setDesc:(NSString *)desc{
    _desc = desc;
    self.labDesc.text = _desc.length>0?self.desc:@"本次版本更新内容如下:";
}
@end
