//
//  XIBTableViewCell.h
//  NIiOS
//
//  Created by nixs on 2018/12/14.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XIBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

@end

NS_ASSUME_NONNULL_END
