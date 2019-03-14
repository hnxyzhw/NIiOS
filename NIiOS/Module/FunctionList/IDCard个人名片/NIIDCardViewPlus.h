//
//  NIIDCardViewPlus.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIIDCardViewPlus : UIView
@property (nonatomic,strong) UIButton* btnHead;
@property (nonatomic,copy) void(^btnHeadClickBlock)(void);
@property(nonatomic,strong)YYAnimatedImageView *imageloadView;//背景图片

@end
