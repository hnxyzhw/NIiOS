
//
//  ProductListCell.m
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "ProductListCell.h"

@implementation ProductListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    //除了可变字体高度其他地方高度=50+10+5+5+kScreenWidth/2.5+5
    CGFloat W_H_Head = 40;
    if (isFullScreen) {
        W_H_Head = 50;
    }
    self.avatarImageView = [UIImageView new];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    NIViewSetRadius(self.avatarImageView, W_H_Head/2);
    UIColor* borderColor = [UIColor redColor];
    NIViewBorderRadius(self.avatarImageView, 1, borderColor.CGColor);
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(W_H_Head, W_H_Head));
        make.top.left.equalTo(self.contentView).offset(10);
    }];
    
    self.name = [UILabel new];
    self.name.textColor = RGBACOLOR(247, 207, 95, 0.8);
    [self.contentView addSubview:self.name];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreenWidth-70-100, 30));
        make.top.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right).offset(5);
    }];
    
    self.time = [UILabel new];
    self.time.textColor = RGBACOLOR(182, 193, 197, 0.8);
    self.time.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.time];
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreenWidth-70-100, 20));
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom);
    }];
    
    self.price = [UILabel new];
    self.price.textColor = [UIColor redColor];
    self.price.textAlignment = NSTextAlignmentRight;
    self.price.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:self.price];
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(100, 30));
        make.centerY.equalTo(self.avatarImageView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.title = [UILabel new];
    self.title.numberOfLines = 0;
    self.title.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.title];
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.right.equalTo(self.price).offset(-5);
        make.top.equalTo(self.time.mas_bottom).offset(5);
    }];
    
    self.productImageView = [UIImageView new];
    self.productImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.productImageView];
    [self.productImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(5);
        make.left.equalTo(self.name.mas_left);
        make.size.equalTo(CGSizeMake(kScreenWidth/2, kScreenWidth/2.5));
    }];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString* productListCellID = @"ProductListCell";
    ProductListCell* cell = [tableView dequeueReusableCellWithIdentifier:productListCellID];
    if (!cell) {
        cell = [[ProductListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productListCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(void)setProduct:(Product *)product{
    _product = product;
    self.name.text = product.name;
    self.time.text = product.date;
    self.price.text = [NSString stringWithFormat:@"¥ %@",product.price];
    self.title.text = product.title;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:product.avatarUrl] options:YYWebImageOptionProgressive];
    [self.productImageView setImageWithURL:[NSURL URLWithString:product.productImageUrl] options:YYWebImageOptionProgressive];
}
@end
