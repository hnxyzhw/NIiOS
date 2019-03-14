


//
//  EditProductViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "EditProductViewController.h"

@interface EditProductViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,assign) BOOL isHaveDian;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;
@end

@implementation EditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布新商品";
    [self setupUI];
    
}
-(void)setupUI{
    self.textView = [YYTextView new];
    NSAttributedString* attriStr = [[NSAttributedString alloc] initWithString:@"请描述商品细节"];
    self.textView.layer.borderWidth = 1.0;
    self.textView.placeholderAttributedText = attriStr;
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.size.equalTo(CGSizeMake(kScreenWidth-20, 100));
        make.centerX.equalTo(self.view);
    }];
    
    self.textField = [UITextField new];
    self.textField.placeholder = @"添加价格";
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(5);
        make.width.equalTo(self.textView);
        make.centerX.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    self.btnPhotoLibraryOrCamera = [UIButton new];
    [self.btnPhotoLibraryOrCamera setTitle:@"添加图片" forState:UIControlStateNormal];
    [self.btnPhotoLibraryOrCamera setBackgroundColor:[UIColor redColor]];
    [self.btnPhotoLibraryOrCamera addTarget:self action:@selector(addImageWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnPhotoLibraryOrCamera];
    [self.btnPhotoLibraryOrCamera makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.size.equalTo(CGSizeMake(150, 40));
    }];
    
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnPhotoLibraryOrCamera.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.size.equalTo(CGSizeMake(kScreenWidth/2, kScreenWidth/3));
    }];
    self.btnPublist = [UIButton new];
    [self.btnPublist setTitle:@"发布产品" forState:UIControlStateNormal];
    [self.btnPublist setBackgroundColor:[UIColor redColor]];
    [self.btnPublist addTarget:self action:@selector(publistBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnPublist];
    [self.btnPublist makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.size.equalTo(CGSizeMake(150, 40));
        make.centerX.equalTo(self.view);
    }];
}
/**发布商品*/
-(void)publistBtn:(UIButton*)btn{
    NSString* title = self.textView.text;
    float price = [self.textField.text floatValue];
    NSNumber* PRICE = [NSNumber numberWithFloat:price];
    AVObject* product = [AVObject objectWithClassName:@"Product"];
    [product setObject:title forKey:@"title"];
    [product setObject:PRICE forKey:@"price"];
    //owner字段为Pointer类型,指向_User表
    AVUser* currentUser = [AVUser currentUser];
    [product setObject:currentUser forKey:@"owner"];
    
    AVFile* file = [AVFile fileWithData:self.imageData];
    [product setObject:file forKey:@"image"];
    [SVProgressHUD showWithStatus:@"发布中..."];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
            [self.view makeToast:@"保存新物品成功." duration:1.5 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeToast:[NSString stringWithFormat:@"保存新物品出错:%@",error.localizedFailureReason] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
/**添加商品*/
-(void)addImageWithBtn:(UIButton*)btn{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请选择添加图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF;
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancle setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    UIAlertAction* photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithPickertype:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [photoLibraryAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithPickertype:UIImagePickerControllerSourceTypeCamera];
    }];
    [cameraAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    [alertController addAction:cancle];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)selectImageWithPickertype:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = sourceType;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }else{
        [self.view makeToast:@"图片库不可用或当前设备没有摄像头" duration:2.0 position:CSToastPositionCenter];
    }
}
#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    NSData* imageData;
    if (UIImagePNGRepresentation(image)) {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    self.imageData = imageData;
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 取消拍照/选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            // 如果第一个输入的是0，那么第二个必须输入小数点
            if([textField.text length] == 1){
                if(!(single == '.') && [[textField.text substringToIndex:1] isEqualToString:@"0"]) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian){//text中还没有小数点
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self.view makeToast:@"数据格式不正确." duration:1.0 position:CSToastPositionCenter];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
@end
