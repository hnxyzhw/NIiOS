//
//  CollectionViewCell.h
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 自定义UICollectionViewCell
 */
@interface CollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *imageViewHeader;
@property(nonatomic,strong) UILabel *labDes;
@property(nonatomic,strong) UIButton *btnItem;
@property(nonatomic,strong) NSIndexPath *indexPath;
/**
 item的点击事件
 */
@property(nonatomic,copy) void (^itemClickedBlock)(NSIndexPath* indexPath);

@end

