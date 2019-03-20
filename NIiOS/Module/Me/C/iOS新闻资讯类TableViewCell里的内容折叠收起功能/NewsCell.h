//
//  NewsCell.h
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel,NewsCell;

NS_ASSUME_NONNULL_BEGIN

@protocol NewsCellDelegate <NSObject>

/**
 折叠按钮点击事件

 @param cell 按钮所属cell
 */
-(void)clickFoldLabel:(NewsCell*)cell;

@end


@interface NewsCell : UITableViewCell
/**
 数据模型
 */
@property(nonatomic,strong) NewsModel *newsModel;
@property(nonatomic,strong) id<NewsCellDelegate> cellDelegate;
@end

NS_ASSUME_NONNULL_END
