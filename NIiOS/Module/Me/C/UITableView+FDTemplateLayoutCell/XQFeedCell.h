//
//  XQFeedCell.h
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XQFeedModel,XQFeedCell;
NS_ASSUME_NONNULL_BEGIN

@interface XQFeedCell : UITableViewCell
@property (strong, nonatomic) XQFeedModel *feed;
@property(nonatomic,copy) void (^foldTapBlock)(XQFeedCell* cell);
@end

NS_ASSUME_NONNULL_END
