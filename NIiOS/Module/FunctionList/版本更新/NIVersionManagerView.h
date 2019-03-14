//
//  NIVersionManagerView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIVersionManagerView : UIView
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* labTitle;
@property(nonatomic,strong)UILabel* labDesc;
@property(nonatomic,strong)NSString* title;//标题
@property(nonatomic,strong)NSString* desc;//描述信息(版本更新内容)

@property(nonatomic,strong)UIButton* btnExit;
@property(nonatomic,strong)UIButton* btnOK;
@property (nonatomic,copy) void(^btnExitBlock)(void);
@property (nonatomic,copy) void(^btnOKBlock)(void);

@end
