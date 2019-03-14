//
//  MeViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "MeViewController.h"
#import "NIIDCardView.h"//个人名片自定义View
#import "NIIDCardViewPlus.h"

@interface MeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NIIDCardView* cardView;//名片自定义View
@property(nonatomic,strong)NIIDCardViewPlus* cardViewPlus;//名片自定义ViewPlus
@property(nonatomic,strong) UIImagePickerController* imagePicker;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupIDCardView];
    [self updateHeadImage];
}
/**
 自定义个人名片视图
 */
-(void)setupIDCardView{
    CGFloat H_Card = (kScreenWidth-20)/2+20;
    self.cardView = [[NIIDCardView alloc] init];
    [self.view addSubview:self.cardView];
    [self.cardView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(H_Card);
    }];
    WEAKSELF;
    [self.cardView setBtnHeadClickBlock:^{
        //[weakSelf.view makeToast:@"第1只猿👨‍💻‍" duration:3.0 position:CSToastPositionTop];
        [weakSelf getNewHeadImage];
    }];
    self.cardViewPlus = [NIIDCardViewPlus new];
    [self.view addSubview:self.cardViewPlus];
    [self.cardViewPlus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(H_Card);
    }];
    [self.cardViewPlus setBtnHeadClickBlock:^{
        //[weakSelf.view makeToast:@"第2只猿👨‍💻‍" duration:3.0 position:CSToastPositionCenter];
        [weakSelf getNewHeadImage];
    }];
}
/**
 获取新头像
 */
-(void)getNewHeadImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        [self.view makeToast:@"图片库不可用" duration:2.0 position:CSToastPositionCenter];
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.cardView.btnHead setBackgroundImage:image forState:UIControlStateNormal];
    [self.cardViewPlus.btnHead setBackgroundImage:image forState:UIControlStateNormal];
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* imageData = UIImagePNGRepresentation(image);
        AVUser* currentUser = [AVUser currentUser];
        AVFile* avatarFile = [AVFile fileWithData:imageData];
        [currentUser setObject:avatarFile forKey:@"avatar"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view makeToast:@"头像上传成功" duration:2.0 position:CSToastPositionCenter];
            });
        }];
    });
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
/**
 更新头像信息
 */
-(void)updateHeadImage{
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求LeanCloud云存储的头像文件
        AVUser* currentUser = [AVUser currentUser];
        AVFile* avatarFile = [currentUser objectForKey:@"avatar"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cardView.btnHead setBackgroundImageWithURL:[NSURL URLWithString:avatarFile.url] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
            [weakSelf.cardViewPlus.btnHead setBackgroundImageWithURL:[NSURL URLWithString:avatarFile.url] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
        });
    });
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
@end
