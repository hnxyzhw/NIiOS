//
//  CommentTableViewCell.m
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configureView];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureView];
    }
    return self;
}

/**
 布局
 */
-(void)configureView{
    CGFloat avatarButtonWidth = 32.0;
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarButton.layer.cornerRadius =  avatarButtonWidth/2.0;
    self.avatarButton.clipsToBounds = YES;
    [self.avatarButton setImage:[UIImage imageNamed:@"apple"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.avatarButton];
    [self.avatarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* view = [[UIView alloc] init];
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:13.0];
    self.nicknameLabel.textColor = [UIColor blackColor];
    self.nicknameLabel.text = @"加菲猫";
    [view addSubview:self.nicknameLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.text = @"2019年01月14日16:13:02";
    [view addSubview:self.timeLabel];
    [self.contentView addSubview:view];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:15.0];
    self.contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLabel];
    
    self.viewBottom = [UIView new];
    self.viewBottom.backgroundColor = [UIColor grayColor];
    self.viewBottom.alpha = 0.5;
    [self.contentView addSubview:self.viewBottom];
    
    [self.avatarButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.equalTo(CGSizeMake(avatarButtonWidth, avatarButtonWidth));
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    [self.nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(view);
    }];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nicknameLabel.mas_leading);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5.0);
        make.bottom.equalTo(view.mas_bottom);
    }];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarButton.mas_trailing).offset(10.0);
        make.trailing.lessThanOrEqualTo(self.contentView.mas_trailing).offset(-10.0);
        make.centerY.equalTo(self.avatarButton.mas_centerY);
    }];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarButton.mas_bottom).offset(10);
        make.leading.equalTo(self.avatarButton.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
    }];
    [self.viewBottom makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(0.5);
    }];
}

- (void)buttonClicked:(id)sender {
    NSLog(@"sssss");
}


@end
