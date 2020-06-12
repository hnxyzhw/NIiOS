//
//  NIIDCardView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 个人名片
 */
@interface NIIDCardView : UIView
@property (nonatomic,strong) UIButton* btnHead;
@property (nonatomic,copy) void(^btnHeadClickBlock)(void);
@end
