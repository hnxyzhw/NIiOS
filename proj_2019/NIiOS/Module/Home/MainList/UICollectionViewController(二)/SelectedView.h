//
//  SelectedView.h
//  NIiOS
//
//  Created by nixs on 2019/2/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedView : UIView
@property(nonatomic,strong) NSArray *titleArray;//标题数组
@property(nonatomic,strong) NSMutableArray *mulArray;//标题下item集合

@property(nonatomic,strong) UIButton *btnReview;
@property(nonatomic,strong) UIButton *btnOk;
@end

