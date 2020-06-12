//
//  MainListTableViewCell.h
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface MainListTableViewCell : UITableViewCell
@property(nonatomic,strong) YYTextView *contentTextView;
- (void)configCellData:(ItemModel *)itemModel;

@end
