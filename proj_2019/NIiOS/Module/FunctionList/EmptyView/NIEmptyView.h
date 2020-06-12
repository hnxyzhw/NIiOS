//
//  NIEmptyView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIEmptyView : UIView
@property(nonatomic,strong)UILabel* labDesc;
@property(nonatomic,strong)UIImageView* imgError;
@property(nonatomic,strong)UIButton* btnRefresh;
@property (nonatomic,copy) void(^refreshBlock)(void);


@end
