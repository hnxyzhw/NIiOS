//
//  NIEmptyView.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIEmptyView.h"

@implementation NIEmptyView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.labDesc = [UILabel new];
    self.labDesc.text = @"数据加载失败";
    self.labDesc.font = [UIFont systemFontOfSize:15];
    self.labDesc.textColor = [UIColor grayColor];
    self.labDesc.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(50);
        make.left.right.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
    }];
    
    self.imgError = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadError"]];
    [self addSubview:self.imgError];
    [self.imgError makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(40);
        make.centerX.equalTo(self);
        make.top.equalTo(self.labDesc).offset(50);
    }];
    
    self.btnRefresh = [UIButton new];
    [self.btnRefresh setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.btnRefresh.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.btnRefresh.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.btnRefresh setTitleColor:kRedColor forState:UIControlStateNormal];
    self.btnRefresh.layer.borderWidth = 1.0;
    self.btnRefresh.layer.borderColor = kRedColor.CGColor;
    //设置圆角
    [self.btnRefresh.layer setCornerRadius:5];
    //切割超出圆角范围的子视图
    self.btnRefresh.layer.masksToBounds = YES;
    
    [self.btnRefresh addTarget:self action:@selector(btnRefreshClicked) forControlEvents:UIControlEventTouchUpInside];
    //[_btnRefresh addTarget:self action:@selector(btnRefreshByEmptyDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnRefresh];
    [self.btnRefresh makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(40);
        make.width.equalTo(120);
        make.top.equalTo(self.imgError).equalTo(60);
        //make.top.equalTo(self.labDesc).equalTo(60);
        make.centerX.equalTo(self);
    }];
    
}
-(void)btnRefreshClicked{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
//-(void)btnRefreshByEmptyDelegate{
//    if ([self.delegate respondsToSelector:@selector(refreshByEmptyView)]) {
//        [self.delegate refreshByEmptyView];
//    }
//}

@end
