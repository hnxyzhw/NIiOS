//
//  PersonHeaderView.h
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonHeaderView : UIView
@property(nonatomic,strong) UIButton *btnHeader;
@property(nonatomic,strong) UILabel *labName;
@property(nonatomic,strong) UIButton *btnExit;
@property(nonatomic,copy) void (^btnHeaderBlock)(void);
@property(nonatomic,copy) void (^btnExitBlock)(void);

/**
 设置头像图片 和 用户名称

 @param url 头像的URL
 @param title 用户名称
 */
-(void)setBtnHeaderBackgroudImageWithURL:(NSString*)url andTitle:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
