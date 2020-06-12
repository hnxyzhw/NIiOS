

//
//  PersonalCenterViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonHeaderView.h"
#import "NITabBarController.h"
#import "Product.h"
#import "ProductListCell.h"
#import "EditProductViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) PersonHeaderView *personHeaderView;//头视图
@property(nonatomic,strong) UIImagePickerController* imagePicker;

@property (nonatomic,strong) NSMutableArray <Product *> *productArr;
@end

@implementation PersonalCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self queryProduct];//请求数据源头
}
#pragma mark -  Private Methods
// LeanCloud - 查询 https://leancloud.cn/docs/leanstorage_guide-objc.html#hash860317
-(void)queryProduct{
    AVQuery* query = [AVQuery queryWithClassName:@"Product"];
    [query orderByDescending:@"createdAt"];
    //owner为Pointer，指向_User表
    [query includeKey:@"owner"];
    //image为File
    [query includeKey:@"image"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.productArr removeAllObjects];
            for (NSDictionary* object in objects) {
                Product* product = [Product initWithObject:object];
                [self.productArr addObject:product];
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    [self setRightNavigationBar];
    [self setupUI];
    [self collectionViewRefresh];//请求数据源头
}

/**新增文案按钮*/
-(void)setRightNavigationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProduct)];
}
/**新增文案跳转*/
-(void)addProduct{
    EditProductViewController* editVC = [EditProductViewController new];
    [self.navigationController pushViewController:editVC animated:YES];
}
-(void)collectionViewRefresh{
    WEAKSELF;
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryProduct];
        //数据请求完成调用
        [weakSelf.tableView.mj_header endRefreshing];
        //[weakSelf.tableView reloadData];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf queryProduct];
        //数据请求完成调用
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData]; // 无数据刷新样式
        //[weakSelf.tableView.mj_footer endRefreshing]; // 普通
        //[weakSelf.tableView reloadData];
    }];
    self.tableView.mj_footer = footer;
}
-(void)setupUI{
    [self setupTableViewWithUITableViewStyle:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[tableView registerClass:[classCell class] forCellReuseIdentifier:kReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//表格之间没有分割线
    self.tableView.tableHeaderView = self.personHeaderView;
    WEAKSELF;
    [self.personHeaderView setBtnHeaderBlock:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            weakSelf.imagePicker.delegate = weakSelf;
            weakSelf.imagePicker.allowsEditing = YES;
            weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
        }else{
            [weakSelf.view makeToast:@"图片库不可用" duration:2.0 position:CSToastPositionCenter];
        }
    }];
    [self.personHeaderView setBtnExitBlock:^{
        [AVUser logOut];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NITabBarController alloc] init];
    }];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.personHeaderView.btnHeader setBackgroundImage:image forState:UIControlStateNormal];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
/**
 //定义个静态字符串为了防止与其他类的tableivew重复
 static NSString *CellIdentifier = @"Cell";
 //定义cell的复用性当处理大量数据时减少内存开销
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell ==nil){
 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 cell.textLabel.text = @"测试表格";
 */
    ProductListCell* cell = [ProductListCell cellWithTableView:tableView];
    if (self.productArr.count>0) {
        cell.product = self.productArr[indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.productArr[indexPath.row].cellHeight;
}
-(PersonHeaderView *)personHeaderView{
    if (!_personHeaderView) {
        _personHeaderView = [[PersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        //请求LeanCloud云存储的头像文件
        AVUser* currentUser = [AVUser currentUser];
        AVFile* avatarFile = [currentUser objectForKey:@"avatar"];
        [_personHeaderView setBtnHeaderBackgroudImageWithURL:avatarFile.url andTitle:currentUser.username];
    }
    return _personHeaderView;
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}
-(NSMutableArray<Product *> *)productArr{
    if (!_productArr) {
        _productArr =[NSMutableArray array];
    }
    return _productArr;
}
@end
