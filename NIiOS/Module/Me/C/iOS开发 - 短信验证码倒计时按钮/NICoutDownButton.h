//
//  NICoutDownButton.h
//  NIiOS
//
//  Created by nixs on 2019/3/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NICoutDownButton;

typedef NSString* (^CountDownChanging)(NICoutDownButton *countDownButton, NSUInteger second);
typedef NSString* (^CountDownFinished)(NICoutDownButton *countDownButton, NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(NICoutDownButton *countDownButton,NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface NICoutDownButton : UIButton
// 倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;

/**
 开始倒计时 -> 计时器改变 -> 结束倒计时
 
 @param second 传入需要倒计时的秒数
 @param countDownChanging 倒计时改变回调
 @param countDownFinished 倒计时结束回调
 */
- (void)startCountDownWithSecond:(NSUInteger)second
               countDownChanging:(CountDownChanging)countDownChanging
               countDownFinished:(CountDownFinished)countDownFinished;
@end

NS_ASSUME_NONNULL_END
