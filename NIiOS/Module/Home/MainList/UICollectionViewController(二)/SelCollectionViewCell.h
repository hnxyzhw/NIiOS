//
//  SelCollectionViewCell.h
//  NIiOS
//
//  Created by nixs on 2019/2/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIButton *btnItem;
@property(nonatomic,strong) NSString* itemTitle;
@property(nonatomic,strong) NSIndexPath *indexPath;

/**
 item的点击事件
 */
@property(nonatomic,copy) void (^itemClickedBlock)(NSIndexPath* indexPath,BOOL isSelected,NSString* itemTitle);
@end

NS_ASSUME_NONNULL_END
