//
//  PCLockLabel.h
//  NIiOS
//
//  Created by nixs on 2018/12/12.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCLockLabel : UILabel
/*
 *  普通提示信息
 */
- (void)showNormalMsg:(NSString *)msg;


/*
 *  警示信息
 */
- (void)showWarnMsg:(NSString *)msg;

/*
 *  警示信息(shake)
 */
- (void)showWarnMsgAndShake:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
