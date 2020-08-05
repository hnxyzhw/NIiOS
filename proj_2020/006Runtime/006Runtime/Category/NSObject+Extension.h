//
//  NSObject+Extension.h
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)
- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
