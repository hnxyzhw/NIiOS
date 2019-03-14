//
//  NIIDCardViewPlus.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIIDCardViewPlus.h"

@implementation NIIDCardViewPlus

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

/**
 个人名片详细UI布局
 */
-(void)setupUI{
    //BgImageView
    self.imageloadView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)/2)];
    //self.imageloadView.contentMode = UIViewContentModeScaleAspectFill;
    //允许上面的Btn可以点击
    self.imageloadView.userInteractionEnabled = YES;
    //YYImage播放动态图片(gif,YYKit实现),内存占用30M
    YYImage *image = [YYImage imageNamed:@"start.gif"];
    [self.imageloadView setImage:image];
    //self.imageloadView.layer.cornerRadius = 5;
    NIViewSetRadius(self.imageloadView, 5);
    
    [self addSubview:self.imageloadView];
    self.imageloadView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageloadView.layer.shadowOpacity = 0.8f;
    self.imageloadView.layer.shadowRadius = 4.f;
    self.imageloadView.layer.shadowOffset = CGSizeMake(4, 4);
    
    //btnHead
    self.btnHead = [UIButton new];
    self.btnHead.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //请求LeanCloud云存储的头像文件
    AVUser* currentUser = [AVUser currentUser];
    AVFile* avatarFile = [currentUser objectForKey:@"avatar"];
    //[self.btnHead setBackgroundImage:[UIImage imageNamed:@"coder.png"] forState:UIControlStateNormal];
    [self.btnHead setBackgroundImageWithURL:[NSURL URLWithString:avatarFile.url] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
    [self.btnHead addTarget:self action:@selector(btnHeadClickedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.imageloadView addSubview:self.btnHead];
    [self.btnHead makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(80);
        make.width.equalTo(80);
        make.top.left.equalTo(self.imageloadView).offset(10);
    }];
    NIViewSetRadius(self.btnHead, 40);
}

/**
 头像按钮点击事件响应
 */
-(void)btnHeadClickedAction{
    if (self.btnHeadClickBlock) {
        self.btnHeadClickBlock();
    }
}

@end
