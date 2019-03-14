
//
//  PersonHeaderView.m
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "PersonHeaderView.h"

@implementation PersonHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    //1.初始化imageView、label(一定记住如下取自定义Cell宽、高方式)
    //CGFloat cellWidth = self.bounds.size.width;
    CGFloat cellHeight = self.bounds.size.height;
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"coder.png"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(button, 5);
    UIColor* borderColor = RGBACOLOR(226, 82, 66, 0.8);
    NIViewBorderRadius(button, 1.0, borderColor.CGColor);
    self.btnHeader = button;
    [self addSubview:self.btnHeader];
    [self.btnHeader makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(cellHeight);
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentLeft;
    //label.textColor = RGBACOLOR(247, 207, 94, 0.8);
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    self.labName = label;
    [self addSubview:self.labName];
    [self.labName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnHeader);
        make.left.equalTo(self.btnHeader.mas_right).offset(10);
        make.right.equalTo(self);
        make.height.equalTo(cellHeight/2);
    }];
    
    UIButton *btnExit = [[UIButton alloc]init];
    [btnExit setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnExit.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnExit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(btnExitClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnExit = btnExit;
    [self addSubview:self.btnExit];
    [self.btnExit makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.size.equalTo(CGSizeMake(100, cellHeight/2));
    }];
}
-(void)setBtnHeaderBackgroudImageWithURL:(NSString *)url andTitle:(NSString *)title{
    [self.btnHeader setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
    self.labName.text = title;
}
-(void)buttonClicked:(UIButton*)btn{
    if (self.btnHeader) {
        self.btnHeaderBlock();
    }
}
-(void)btnExitClicked:(UIButton*)btn{
    if (self.btnExitBlock) {
        self.btnExitBlock();
    }
}
@end
