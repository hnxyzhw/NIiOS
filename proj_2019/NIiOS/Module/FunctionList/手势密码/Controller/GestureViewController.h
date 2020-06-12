//
//  GestureViewController.h
//  NIiOS
//
//  Created by nixs on 2018/12/12.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIBaseViewController.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

NS_ASSUME_NONNULL_BEGIN

@interface GestureViewController : NIBaseViewController
/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;
@end

NS_ASSUME_NONNULL_END
