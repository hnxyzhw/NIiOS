

//
//  XQFeedCell.m
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "XQFeedCell.h"
#import "XQFeedModel.h"
@interface XQFeedCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation XQFeedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        [self createView];
        [self setttingViewAtuoLayout];
    }
    return self;
}
#pragma mark - 在此方法内使用Masonry设置控件的约束，设置约束不需要在layoutSubviews中设置,只需要在初始化的时候设置
-(void)setttingViewAtuoLayout {
    int margin = 4;
    int padding =10;
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.contentView).offset(padding);
        make.right.equalTo(self.contentView).offset(-padding);
    }];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(margin);
    }];
    [self.contentImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(margin);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    [self.userLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(margin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin);
    }];
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.userLabel);
        make.right.equalTo(self.titleLabel.mas_right);
    }];
}
// 如果你是自动布局子控件，就不需要实现此方法，如果是计算子控件frame的话就需要实现此方法
//- (CGSize)sizeThatFits:(CGSize)size {
//
//    CGFloat cellHeight = 0;
//
//    cellHeight += [self.titleLabel sizeThatFits:size].height;
//    cellHeight += [self.contentLabel sizeThatFits:size].height;
//    cellHeight += [self.contentImageView sizeThatFits:size].height;
//    cellHeight += [self.userLabel sizeThatFits:size].height;
//    cellHeight += 40;
//
//    return CGSizeMake(size.width, cellHeight);
//}

/**
 *  设置控件属性
 */
- (void)setFeed:(XQFeedModel *)feed {
    
    _feed = feed;
    
    self.titleLabel.text = feed.title;
    self.contentLabel.text = feed.content;
    self.contentImageView.image = feed.imageName.length > 0 ? [UIImage imageNamed:feed.imageName] : nil;
    self.userLabel.text = feed.username;
    self.timeLabel.text = feed.time;
}
#pragma make 创建子控件
-(void)createView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.textColor = RGBACOLOR(125, 125, 125, 0.8);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.font = [UIFont systemFontOfSize:15.f];
    userLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:userLabel];
    self.userLabel = userLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
}
@end
