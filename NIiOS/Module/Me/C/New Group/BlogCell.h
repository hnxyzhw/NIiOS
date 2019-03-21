//
//  BlogCell.h
//  NIiOS
//
//  Created by nixs on 2019/3/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlogModel,BlogCell;
@protocol BlogCellDelegate <NSObject>

/**
 折叠按钮点击事件
 
 @param cell 按钮所属cell
 */
-(void)clickFoldLabel:(BlogCell*)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BlogCell : UITableViewCell
@property(nonatomic,strong) BlogModel* blogModel;
@property(nonatomic,strong) id<BlogCellDelegate> cellDelegate;

/**
 上面的代理事件-改成block实现
 */
@property(nonatomic,copy) void (^foldClickedBlock)(BlogCell* cell);
@end

NS_ASSUME_NONNULL_END
