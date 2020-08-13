//
//  TMAddCategoryViewController.h
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMAddCategoryViewController : BaseViewController

/// 属性 自动声明实例变量和存取方法，并实现存取方法
@property(nonatomic,strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
