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
#import "HomeModel.h"
#import "MainListTableViewCell.h"
#import "HomeDataSupport.h"
#import "NewsViewController.h"
#import "XQTableViewController.h"
#import "NIWebViewController.h"//集成自cocoapods引入第三方创建自定义NIWebViewController.h/m
#import "H5EnterModel.h"
#import "GetSizeOfImageViewController.h"
#import "CountDownButtonViewController.h"
#import "A_ViewController.h"
#import "BlogViewController.h"
#import "SimpleViewController.h"

@interface MeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray* arrayAll;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *arr;
@property(nonatomic,strong)NIIDCardView* cardView;//名片自定义View
@property(nonatomic,strong)NIIDCardViewPlus* cardViewPlus;//名片自定义ViewPlus
@property(nonatomic,strong) UIImagePickerController* imagePicker;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupIDCardView];
    [self updateHeadImage];
    
    //初始化数据源
    [self refreshDataArray];
    //初始化表格
    [self setupTable];
    //表格刷新
    [self tableRefresh];
}
#pragma mark - 刷新表格数据源
-(void)refreshDataArray{
#pragma mark - 从json文件里获取数据源
    [self.arr removeAllObjects];//清空数据集
    HomeDataSupport *ds = [HomeDataSupport new];
    self.arr = [ds getDataSourceWithFileName:@"mine.json"];
    //[self.tableView reloadData];
}
/**
 初始化表格
 */
-(void)setupTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.height = UITableViewAutomaticDimension;       //自动调整约束，性能非常低，灰常的卡
    self.tableView.estimatedRowHeight = 100.0;  //设置预估值
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerClass:NSClassFromString(@"MainListTableViewCell") forCellReuseIdentifier:@"MainListTableViewCell"];
    //重写tableView布局
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.cardViewPlus.mas_bottom).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.cardViewPlus.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.leading.trailing.equalTo(self.view);
    }];
    self.tableView.sectionFooterHeight = 0;
}
-(void)tableRefresh{
    WEAKSELF;
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData]; // 无数据刷新样式
        //[weakSelf.tableView.mj_footer endRefreshing]; // 普通
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_footer = footer;
}

/**
 区头布局
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* viewForHeader = [UIView new];
    HomeModel* homeModel = self.arr[section];
    UILabel* labViewForHeader = [UILabel new];
    labViewForHeader.font = [UIFont systemFontOfSize:12.0];
    labViewForHeader.text = homeModel.title;
    labViewForHeader.textColor = [UIColor redColor];
    labViewForHeader.textAlignment = NSTextAlignmentLeft;
    [viewForHeader addSubview:labViewForHeader];
    [labViewForHeader makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForHeader.mas_top).offset(10);
        make.left.equalTo(viewForHeader.mas_left).offset(10);
        make.right.equalTo(viewForHeader.mas_right);
        make.bottom.equalTo(viewForHeader.mas_bottom).offset(-5);
    }];
    return viewForHeader;
}
//cell高度计算
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel* homeModel = self.arr[indexPath.section];
    ItemModel* itemModel = homeModel.item[indexPath.row];
    return itemModel.cellHeight;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeModel* homeModel = self.arr[section];
    return homeModel.body.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainListTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MainListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainListTableViewCell"];
    }
    HomeModel* homeModel = self.arr[indexPath.section];
    ItemModel* itemModel = homeModel.item[indexPath.row];
    [cell configCellData:itemModel];
    if (indexPath.section==6) {
        cell.contentTextView.textColor = [UIColor redColor];//多线程
        if (indexPath.row==7) {
            cell.contentTextView.textColor = [UIColor grayColor];
        }else if (indexPath.row>7) {
            cell.contentTextView.textColor = [UIColor blueColor];
        }
    }else if(indexPath.section==11){
        cell.contentTextView.textColor = [UIColor purpleColor];//UICollectionView
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel* homeModel = self.arr[indexPath.section];
    NSArray* arrayBody = homeModel.body;
    ///////////////////0.支付//////////////////////////
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            ///////////////////1.第三方登陆分享//////////////////////////
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            ///////////////////1.效果//////////////////////////
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    break;
                }
                case 1:{//iOS新闻资讯类TableViewCell里的内容折叠收起功能 https://www.jianshu.com/p/f8acc4f6a540
                    NewsViewController* newsVC = [NewsViewController new];
                    [self pushVC:newsVC];
                    break;
                }
                case 2:{
                    XQTableViewController* xqVC = [XQTableViewController new];
                    [self pushVC:xqVC];
                    break;
                }
                case 3:{
                    H5EnterModel *model1 = [[H5EnterModel alloc] init];
                    model1.title = @"优化UITableViewCell高度计算的那些事";
                    model1.detailTitle = @"UITableView+FDTemplateLayoutCell";
                    model1.url = @"http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/";
                    //新增了 X 关闭按钮的资源文件（图片资源）
                    //修改了源码里文件 JXBWebViewController.m line:265
                    //JXBWebViewController *niWebVC = [[JXBWebViewController alloc] initWithURLString:model1.url];
                    NIWebViewController *niWebVC = [[NIWebViewController alloc] initWithURLString:model1.url];
                    [self.navigationController pushViewController:niWebVC animated:YES];
                    break;
                }
                case 4:{
                    GetSizeOfImageViewController* getSizeVC = [GetSizeOfImageViewController new];
                    [self pushVC:getSizeVC];
                    break;
                }
                case 5:{
                    CountDownButtonViewController* coutDownVC = [CountDownButtonViewController new];
                    [self pushVC:coutDownVC];
                    break;
                }
                case 6:{
                    A_ViewController *aVC = [A_ViewController new];
                    [self pushVC:aVC];
                    break;
                }
                case 7:{
                    BlogViewController* blogVC = [BlogViewController new];
                    [self pushVC:blogVC];
                    break;
                }
                case 8:{
                    SimpleViewController* simpleVC = [SimpleViewController new];
                    [self pushVC:simpleVC];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    //0.iOS完美实现微信朋友圈视频截取 http://flyoceanfish.top/2018/07/13/iOS%E5%AE%8C%E7%BE%8E%E5%AE%9E%E7%8E%B0%E5%BE%AE%E4%BF%A1%E6%9C%8B%E5%8F%8B%E5%9C%88%E8%A7%86%E9%A2%91%E6%88%AA%E5%8F%96/
                    [self.view makeToast:@"0.iOS完美实现微信朋友圈视频截取" duration:1.0 position:CSToastPositionCenter];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 4:{
            switch (indexPath.row) {
                case 0:{
                    [self.view makeToast:@"0.高德地图获取经纬度-测试" duration:1.0 position:CSToastPositionCenter];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:{
            [self.view makeToast:arrayBody[indexPath.row]];
            break;
        }
    }
}

/**
 push VC
 */
-(void)pushVC:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 可变数组懒加载
 */
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
/**
 自定义个人名片视图
 */
-(void)setupIDCardView{
    CGFloat H_Card = (kScreenWidth-20)/3;
    self.cardView = [[NIIDCardView alloc] init];
    [self.view addSubview:self.cardView];
    [self.cardView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide);
        }
        make.leading.trailing.equalTo(self.view);
        //make.height.equalTo(H_Card);
        make.height.equalTo(0);
    }];
    WEAKSELF;
    [self.cardView setBtnHeadClickBlock:^{
        //[weakSelf.view makeToast:@"第1只猿👨‍💻‍" duration:3.0 position:CSToastPositionTop];
        [weakSelf getNewHeadImage];
    }];
    self.cardViewPlus = [NIIDCardViewPlus new];
    [self.view addSubview:self.cardViewPlus];
    [self.cardViewPlus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.view);
        //make.height.equalTo(H_Card);
        make.height.equalTo(0);
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
