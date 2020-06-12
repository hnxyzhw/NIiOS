//
//  EditProductViewController.h
//  NIiOS
//
//  Created by nixs on 2019/3/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NIBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProductViewController : NIBaseViewController
@property(nonatomic,strong) YYTextView *textView;
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton *btnPhotoLibraryOrCamera;
@property(nonatomic,strong) UIButton *btnPublist;

@end

NS_ASSUME_NONNULL_END
