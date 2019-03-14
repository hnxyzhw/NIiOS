//
//  NINetWorkDetectionView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NINetWorkDetectionView : UIView
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* labDesc;
@property (nonatomic,strong)UIWindow *alertWindow;
@property(nonatomic,strong)UIImageView* noNetWorkImageView;

-(void)showNINetworkDetectionView;

@end
