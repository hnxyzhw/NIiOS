
//
//  NewsCell.m
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NewsCell.h"
#import "NewsModel.h"

@interface NewsCell()
@property(nonatomic,strong) UILabel *newsText;//新闻文本
@property(nonatomic,strong) UILabel *foldLabel;//展开按钮
@property(nonatomic,strong) UILabel* newsDate;//日期
@property(nonatomic,strong) UIView *bottomSpaceView;//底部分割线
@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation NewsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self.contentView addSubview:self.newsText];
    [self.contentView addSubview:self.newsDate];
    [self.contentView addSubview:self.foldLabel];
    [self.contentView addSubview:self.bottomSpaceView];
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    [self.newsText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    self.newsText.preferredMaxLayoutWidth = kScreenWidth-10-10-1;
    [self.newsDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newsText.mas_bottom).offset(12);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(100);
    }];
    [self.foldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsText.mas_left);
        make.width.equalTo(50);
        make.height.equalTo(44);
        make.centerY.equalTo(self.newsDate);
    }];
    [self.contentImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldLabel.mas_bottom).offset(margin);
        make.left.equalTo(self.newsText.mas_left);
    }];
    [self.bottomSpaceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(10);
        make.left.equalTo(self.newsText);
        make.right.equalTo(self.contentView);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
}
-(void)setNewsModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
    self.newsText.text = newsModel.desc;
    //可以在这里修改行间距，下面的计算文本高度的时候也要对应设置
    //如果不需要修改,可以省去这一步，但注意下面获取敢赌的时候不要再设置行间距
    if (self.newsText.text.length>0) {
        NSMutableAttributedString* img_text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",newsModel.desc]];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [img_text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.newsText.text.length)];
        self.newsText.attributedText = img_text;
    }
    //获取文本内容的宽度,计算展开全部文本所需高度
    CGFloat contentW = kScreenWidth-20;
    NSString* contentStr=self.newsText.text;
    NSMutableParagraphStyle* descStyle=[[NSMutableParagraphStyle alloc] init];
    [descStyle setLineSpacing:3];//行间距
    CGRect textRect = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSParagraphStyleAttributeName:descStyle} context:nil];
    //这里的高度60是通过制定显示三行文字时候，通过打印得到的一个临界值，根据需要自行修改
    //超过三行文字，折叠按钮不显示
    if (textRect.size.height>66) {
        self.foldLabel.hidden = NO;
        //修改按钮的折叠打开状态
        if (newsModel.isOpening) {
            self.newsText.numberOfLines = 0;
            self.foldLabel.text = @"收起";
        }else{
            self.newsText.numberOfLines = 3;
            self.foldLabel.text = @"展开";
        }
    }else{
        self.newsText.numberOfLines = 0;
        self.foldLabel.hidden = YES;
    }
    NSTimeInterval time = [newsModel.pubdate doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [dateFormatter stringFromDate:detaildate];
    if (dateStr.length > 0) {
        //日期
        self.newsDate.text = [dateStr substringWithRange:NSMakeRange(0, 10)];
    }
    //NSString* imageName = [NSString stringWithFormat:@"%d",[self getRandomNumber:0 to:5]];
    self.contentImageView.image = newsModel.imageName.length > 0 ? [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",newsModel.imageName]] : nil;
    
    //如下重新更新图片布局会有异常待解决；
//    if (newsModel.imageName.length>0) {
//        self.contentImageView.image = [UIImage imageNamed:newsModel.imageName];
//        // 获取图片的size
//        CGSize imageSize = [UIImage imageNamed:newsModel.imageName].size;
//        [self.contentImageView updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(imageSize.width/2, imageSize.height/2));
//        }];
//    }else{
//        self.contentImageView.image = nil;
//    }
    
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
-(UIView *)bottomSpaceView{
    if (!_bottomSpaceView) {
        _bottomSpaceView = [UIView new];
        _bottomSpaceView.backgroundColor =[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1];
    }
    return _bottomSpaceView;
}
-(UILabel *)newsDate{
    if (!_newsDate) {
        _newsDate = [UILabel new];
        _newsDate.textColor = [UIColor blackColor];
        _newsDate.font = [UIFont systemFontOfSize:13.0f];
        _newsDate.textAlignment = NSTextAlignmentRight;
        _newsDate.numberOfLines = 1;
    }
    return _newsDate;
}
-(UILabel*)foldLabel{
    if (!_foldLabel) {
        _foldLabel = [UILabel new];
        _foldLabel.font = [UIFont systemFontOfSize:14.f];
        _foldLabel.textColor = [UIColor redColor];
        _foldLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer* foldTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldNewsOrNoTap:)];
        [_foldLabel addGestureRecognizer:foldTap];
        _foldLabel.hidden = YES;
        [_foldLabel sizeToFit];
    }
    return _foldLabel;
}

/** Gesture
 折叠展开按钮的点击事件
 @param recognizer 点击手势
 */
- (void)foldNewsOrNoTap:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(clickFoldLabel:)]) {
            [self.cellDelegate clickFoldLabel:self];
        }
    }
}
-(UILabel *)newsText{
    if (!_newsText) {
        _newsText = [UILabel new];
        _newsText.textColor = [UIColor blackColor];
        _newsText.font = [UIFont systemFontOfSize:18.0f];
    }
    return _newsText;
}
@end
