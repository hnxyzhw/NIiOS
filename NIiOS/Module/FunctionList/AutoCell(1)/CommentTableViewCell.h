//
//  CommentTableViewCell.h
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView  *viewBottom;
@end

