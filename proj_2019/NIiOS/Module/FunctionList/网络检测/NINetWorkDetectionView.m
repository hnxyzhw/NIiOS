//
//  NINetWorkDetectionView.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NINetWorkDetectionView.h"
#define MainScreenRect [UIScreen mainScreen].bounds

@implementation NINetWorkDetectionView

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
        make.height.equalTo(135);
        make.center.equalTo(self);
    }];
    [self.bgView.layer setCornerRadius:5];
    
    self.noNetWorkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"netError"]];
    [self.bgView addSubview:self.noNetWorkImageView];
    [self.noNetWorkImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(50);
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView.mas_top).offset(15);
    }];
    
    self.labDesc = [UILabel new];
    self.labDesc.text = @"网络异常或断开连接,\n请检查手机网络!";
    self.labDesc.font = [UIFont systemFontOfSize:18];
    self.labDesc.textColor = [UIColor redColor];
    self.labDesc.textAlignment = NSTextAlignmentCenter;
    self.labDesc.numberOfLines = 0;
    [self.bgView addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noNetWorkImageView.mas_bottom).offset(5);
        //make.height.equalTo(50);
        make.left.right.equalTo(self.bgView);
    }];
}
-(void)showNINetworkDetectionView{
    _alertWindow=[[UIWindow alloc] initWithFrame:MainScreenRect];
    _alertWindow.windowLevel=UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    [_alertWindow addSubview:self];
    //[self setShowAnimation];
}

@end
