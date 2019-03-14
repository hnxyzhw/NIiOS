//
//  UIImage+Tools.h
//  NIiOS
//
//  Created by nixs on 2019/2/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tools)

/**
 添加一个新属性：图片网络链接
 */
@property(nonatomic,copy) NSString *urlString;

-(void)clearAssociatedObject;
@end

NS_ASSUME_NONNULL_END
