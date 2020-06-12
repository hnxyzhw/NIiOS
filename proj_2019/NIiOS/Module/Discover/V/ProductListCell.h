//
//  ProductListCell.h
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProductListCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
/**
 头像imageView
 */
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *title;

/**
 产品imageView
 */
@property (strong, nonatomic) UIImageView *productImageView;

@property (nonatomic,strong) Product  * product;

@end

NS_ASSUME_NONNULL_END
