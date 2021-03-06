//
//  Game.h
//  runtime002
//
//  Created by ai-nixs on 2020/7/19.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject

- (void)Play;

- (void)DoThings:(NSString *)Str Num:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
