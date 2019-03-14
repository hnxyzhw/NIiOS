//
//  CollectionReusableView.h
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableView : UICollectionReusableView
@property(nonatomic,strong) UIView *viewLeft;//左边开始自定义view(蓝色)
@property(nonatomic,strong) UILabel *labSectionHeader;

@end

