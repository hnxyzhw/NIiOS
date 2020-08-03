//
//  ViewController.h
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/23.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明
typedef void(^ClickBlock)(NSInteger index);


//作为属性
typedef void(^handleBlock)();

@interface ViewController : UIViewController
//block属性
@property(nonatomic,copy) ClickBlock imageClickBlock;

//@property(nonatomic,copy) return_type (^blockName)(var_type);
//按钮点击Block
@property(nonatomic,copy) void (^btnClickBlock)(UIButton* sender);

-(void)requestForRefuseOrAccept:(NSString*)name handle:(handleBlock)handleBlock;

//在定义方法时，声明Block型的形参
//-(void)yourMethod:(return_type(^)(var_type))blockName;
-(void)addClickedBlock:(void(^)(id obj))clickedAction;


@end

