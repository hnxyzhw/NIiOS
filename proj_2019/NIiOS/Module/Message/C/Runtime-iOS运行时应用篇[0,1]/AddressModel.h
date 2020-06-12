//
//  AddressModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/1.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject
@property(nonatomic,strong) NSString *country;//国籍
@property(nonatomic,strong) NSString *province;//省份
@property(nonatomic,strong) NSString *city;//城市
@end

NS_ASSUME_NONNULL_END
