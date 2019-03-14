
//
//  MainListTableViewCell.m
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import "MainListTableViewCell.h"

@interface MainListTableViewCell()
@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) YYLabel *titleLable;
@property (strong, nonatomic) YYLabel *timeLabel;

@end

@implementation MainListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addHeaderImageView];
        [self addTitle];
        [self addTime];
        [self addTextView];
    }
    return self;
}
- (void)addHeaderImageView {
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.borderColor = RGBACOLOR(54, 87, 149, 0.5).CGColor;
    self.headerImageView.layer.borderWidth = 1.0;
    [self addSubview:self.headerImageView];
}

- (void)addTitle {
    self.titleLable = [[YYLabel alloc] initWithFrame:CGRectMake(60, 10, kScreenWidth-60, 20)];
    self.titleLable.font = [UIFont boldSystemFontOfSize:15];
    self.titleLable.textColor = RGBACOLOR(96, 178, 225, 0.8);
    [self addSubview:self.titleLable];
}

- (void)addTime {
    self.timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(60, 30, kScreenWidth-60, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self addSubview:self.timeLabel];
}

- (void)addTextView {
    self.contentTextView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 55, kScreenWidth - 20, 10)];
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    self.contentTextView.textColor = [UIColor grayColor];
    self.contentTextView.editable = NO;
    self.contentTextView.scrollEnabled = NO;
    [self addSubview:self.contentTextView];
}

- (void)configCellData:(ItemModel *)itemModel{
    //[[YYMemoryCache alloc] init];
    [self.headerImageView setImage:[UIImage imageNamed:itemModel.imageNameItem]];
    //[self.headerImageView setImage:[YYImage imageNamed:itemModel.imageNameItem]];     //直接创建
    //[self.headerImageView setImage:[[ImageCache shareInstance] getCacheYYImage:itemModel.imageNameItem]];
    
    [self.titleLable setText:itemModel.titleItem];
    [self.timeLabel setText:itemModel.timeItem];
    self.contentTextView.height = itemModel.textHeight;
    self.contentTextView.attributedText = itemModel.attributeContent;
}

@end
