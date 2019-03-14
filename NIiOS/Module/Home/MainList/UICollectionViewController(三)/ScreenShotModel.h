//
//  ScreenShotModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/12.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenShotModel : NSObject

/**
 截图存储id
 */
@property(nonatomic,strong)NSString* objectId;
/**
 截图存储name
 */
@property(nonatomic,strong)NSString* name;
/**
 截图存储url
 */
@property(nonatomic,strong)NSString* url;
/**
 截图存储mime_type
 */
@property(nonatomic,strong)NSString* mime_type;
/**
 截图存储metaData
 */
@property(nonatomic,strong)NSString* metaData;

@end

NS_ASSUME_NONNULL_END
