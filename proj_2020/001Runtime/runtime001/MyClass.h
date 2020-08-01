//
//  MyClass.h
//  runtime001
//
//  Created by nixs on 2020/7/15.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyClass : NSObject
+(BOOL)resolveInstanceMethod:(SEL)aSEL;
@end

NS_ASSUME_NONNULL_END
