//
//  NIIDCardView.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIIDCardView.h"

@implementation NIIDCardView

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
    UIView* cardView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)/2)];
    cardView.backgroundColor = NICOLOR_FROM_RGB_OxFF_ALPHA(0xfde2b1, 1);
    cardView.userInteractionEnabled = YES;
    cardView.layer.cornerRadius = 5;
    //NIViewSetRadius(cardView, 5);//会丢失阴影
    [self addSubview:cardView];
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOpacity = 0.8f;
    cardView.layer.shadowRadius = 4.f;
    cardView.layer.shadowOffset = CGSizeMake(4, 4);
    
    //btnHead
    self.btnHead = [UIButton new];
    self.btnHead.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //请求LeanCloud云存储的头像文件
    AVUser* currentUser = [AVUser currentUser];
    AVFile* avatarFile = [currentUser objectForKey:@"avatar"];
    //[self.btnHead setBackgroundImage:[UIImage imageNamed:@"coder.png"] forState:UIControlStateNormal];
    [self.btnHead setBackgroundImageWithURL:[NSURL URLWithString:avatarFile.url] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
    [self.btnHead addTarget:self action:@selector(btnHeadClickedAction) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:self.btnHead];
    [self.btnHead makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(80);
        make.width.equalTo(80);
        make.top.left.equalTo(cardView).offset(10);
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
