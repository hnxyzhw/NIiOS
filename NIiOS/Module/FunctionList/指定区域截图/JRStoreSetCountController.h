//
//  JRStoreSetCountController.h
//  Pos
//
//  Created by 艾小新 on 2018/5/26.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import "NIBaseViewController.h"
#import "JRStoreDetailModel.h"

typedef void(^countBlock)(JRStoreDetailModel *);
@interface JRStoreSetCountController : NIBaseViewController

@property (nonatomic,copy) countBlock countBlock;

@end
