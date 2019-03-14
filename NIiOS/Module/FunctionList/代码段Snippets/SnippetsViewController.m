
//
//  SnippetsViewController.m
//  NIiOS
//
//  Created by nixs on 2018/12/8.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "SnippetsViewController.h"

@interface SnippetsViewController ()
@property(nonatomic,strong)UIView* headView;
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)UILabel* labDesc;

@end

@implementation SnippetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"Xcode 10.1使用代码段";
    [self setupUI];
}
#pragma mark 初始化UI
-(void)setupUI{
    self.headView = [UIView new];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-10);
        }
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
    }];
    
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.headView);
        make.height.equalTo(300);
    }];
    #pragma mark imageView加边框&加边框宽度&加边框颜色，圆角
    NIViewBorderRadius(self.imageView, 10, [UIColor redColor].CGColor)
    NIViewSetRadius(self.imageView, 10)
    
    #pragma mark 异步加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544268338039&di=2edbe45b4e0418c23b12bc3f86f0cd24&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201508%2F12%2F20150812232534_YdKFc.jpeg"];
        NSData* data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:data];
        if (data!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:image];
            });
        }
    });
    #pragma mark 提示信息
    self.labDesc = [UILabel new];
    self.labDesc.text = @"Hi,3秒后将要变身...";
    self.labDesc.textAlignment = NSTextAlignmentCenter;
    self.labDesc.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.equalTo(self.imageView);
        make.height.equalTo(50);        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(500);
        }];
        [self.imageView setImage:[UIImage imageNamed:@"加菲猫2"]];
        self.labDesc.text = @"YEAH,变身成功!😏";
    });
    
}

@end
