
//
//  BlogCell.m
//  NIiOS
//
//  Created by nixs on 2019/3/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "BlogCell.h"
#import "BlogModel.h"

@interface BlogCell()
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) UILabel *labContent;
@property(nonatomic,strong) UILabel *foldLabel;//展开按钮
@property(nonatomic,strong) UILabel *labTime;
@property(nonatomic,strong) UIView *bottomSpaceView;//底部分割线
@end

@implementation BlogCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.labContent];
    [self.contentView addSubview:self.foldLabel];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.bottomSpaceView];
    //如下方式是错误的
//    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.labTime.mas_bottom).offset(5);
//    }];
    
    //如下是正确的方式
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [self.labContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.right.equalTo(self.labTitle);
    }];
    
    self.labContent.preferredMaxLayoutWidth = kScreenWidth-10-10-1;//这里这句话是重点！！！，不加此句话可能会引起布局异常；
    
    [self.labTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(kScreenWidth*2/3);
    }];
    [self.foldLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labContent.mas_left);
        make.width.equalTo(50);
        make.height.equalTo(44);
        make.centerY.equalTo(self.labTime);
    }];
    [self.bottomSpaceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(0);
        make.left.equalTo(self.labTitle);
        make.right.equalTo(self.contentView);
        make.height.equalTo(0.1);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}
-(void)setBlogModel:(BlogModel *)blogModel{
    _blogModel = blogModel;
    self.labTitle.text = blogModel.title.length>0?blogModel.title:@"";
    self.labContent.text = blogModel.content.length>0?blogModel.content:@"";
    //可以在这里修改行间距，下面的计算文本高度的时候也要对应设置
    //如果不需要修改,可以省去这一步，但注意下面获取敢赌的时候不要再设置行间距
    if (self.labContent.text.length>0) {
        NSMutableAttributedString* img_text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",blogModel.content]];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        [img_text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.labContent.text.length)];
        self.labContent.attributedText = img_text;
    }
    //获取文本内容的宽度,计算展开全部文本所需高度
    CGFloat contentW = kScreenWidth-20;
    NSString* contentStr=self.labContent.text;
    NSMutableParagraphStyle* descStyle=[[NSMutableParagraphStyle alloc] init];
    [descStyle setLineSpacing:0];//行间距
    CGRect textRect = [contentStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSParagraphStyleAttributeName:descStyle} context:nil];
    //这里的高度60是通过制定显示三行文字时候，通过打印得到的一个临界值，根据需要自行修改
    //超过三行文字，折叠按钮不显示
    if (textRect.size.height>59.5) {
        self.foldLabel.hidden = NO;
        //修改按钮的折叠打开状态
        if (blogModel.isOpening) {
            self.labContent.numberOfLines = 0;
            self.foldLabel.text = @"收起";
        }else{
            self.labContent.numberOfLines = 3;
            self.foldLabel.text = @"展开";
        }
    }else{
        self.labContent.numberOfLines = 0;
        self.foldLabel.hidden = YES;
    }
    self.labTime.text = blogModel.time.length>0?blogModel.time:@"";
}
-(UIView *)bottomSpaceView{
    if (!_bottomSpaceView) {
        _bottomSpaceView = [UIView new];
        _bottomSpaceView.backgroundColor =[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1];
    }
    return _bottomSpaceView;
}
-(UILabel *)labTime{
    if (!_labTime) {
        _labTime = [UILabel new];
        _labTime.textColor = [UIColor grayColor];
        _labTime.numberOfLines = 1;
        //_labTime.adjustsFontSizeToFitWidth=YES;//如果宽度不够，这里文字内容会自动缩小自适应
        _labTime.textAlignment = NSTextAlignmentRight;
        _labTime.font = [UIFont systemFontOfSize:15.f];
    }
    return _labTime;
}
-(UILabel *)labContent{
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.textColor = [UIColor grayColor];
        _labContent.font = [UIFont systemFontOfSize:15.f];
    }
    return _labContent;
}
-(UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.textColor = [UIColor blackColor];
        _labTitle.numberOfLines = 0;
        _labTitle.font = [UIFont boldSystemFontOfSize:18.f];
    }
    return _labTitle;
}
-(UILabel*)foldLabel{
    if (!_foldLabel) {
        _foldLabel = [UILabel new];
        _foldLabel.font = [UIFont systemFontOfSize:15.f];
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
        if (self.foldClickedBlock) {
            self.foldClickedBlock(self);
        }
    }
}
@end
