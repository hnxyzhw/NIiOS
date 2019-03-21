//
//  BlogModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlogModel : NSObject
@property(nonatomic,strong) NSString *title;//标题
@property(nonatomic,strong) NSString *content;//内容
/**
 修改时间
 */
@property(nonatomic,strong) NSString *time;
/**
 是否展开
 */
@property(nonatomic,assign) BOOL isOpening;
@end

NS_ASSUME_NONNULL_END
