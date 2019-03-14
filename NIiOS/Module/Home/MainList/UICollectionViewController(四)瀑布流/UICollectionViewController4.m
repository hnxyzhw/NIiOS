//
//  UICollectionViewController4.m
//  NIiOS
//
//  Created by nixs on 2019/3/12.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "UICollectionViewController4.h"
#import "CollectionReusableView.h"//自定义头/尾视图
#import "CollectionViewCell.h"//自定义UICollectionViewCell
#import "SimpleModel.h"//数据源
#import "ScreenShotModel.h"//数据源
#import "CustomeCollectionViewLayout.h"
#import "YYPhotoGroupView.h"

@interface UICollectionViewController4 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) CustomeCollectionViewLayout *flowLayout;
@property (strong, nonatomic) ScreenShotModel *screenShotModel;
@property (strong, nonatomic) NSMutableArray *mulArray;

@end
static NSString * const cellIdentifier = @"cellIdentifier";
static NSString * const headerIdentifier = @"headerIdentifier";
@implementation UICollectionViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    //参考：https://www.cnblogs.com/ludashi/p/4791826.html
    self.navigationItem.title = @"UICollectionViewController(三)截屏数据展示";
    //添加collectionView to self.view
    [self.view addSubview:self.collectionView];
    //Masnory布局
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.left.right.equalTo(self.view);
    }];
    
    //注册cell、headerView/footerView
    //[self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    [self refreshDataArray];
    [self collectionViewRefresh];
}
-(void)collectionViewRefresh{
    WEAKSELF;
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.collectionView.mj_header endRefreshing];
        //[weakSelf.collectionView reloadData];
    }];
    self.collectionView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData]; // 无数据刷新样式
        //[weakSelf.tableView.mj_footer endRefreshing]; // 普通
        //[weakSelf.collectionView reloadData];
    }];
    self.collectionView.mj_footer = footer;
}
-(void)refreshDataArray{
    //初始化数据源
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVQuery *query = [AVQuery queryWithClassName:@"imageData"];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                [weakSelf.mulArray removeAllObjects];
                for (int i=0; i<((NSArray*)objects).count; i++) {
                    DLog(@"---[%d]:url:%@",i,((AVFile*)objects[i][@"screenData"]).url);
                    AVFile* avFile = (AVFile*)objects[i][@"screenData"];
                    [weakSelf.mulArray addObject:avFile];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }
        }];
    });
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mulArray count];
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionReusableView* reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //设置Header内容
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        //resuableView.labSectionHeader.textAlignment = NSTextAlignmentCenter;
        reusableView.labSectionHeader.text = [NSString stringWithFormat:@"Section %li",indexPath.section];
        reusableView.backgroundColor = RGBACOLOR(122, 145, 159, 1);
        reusableView.labSectionHeader.textColor = [UIColor blackColor];
    }
    return reusableView;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    //设置imageView图片、lab文字
    if (self.mulArray.count>0) {
        AVFile* avFile = self.mulArray[indexPath.item];
        NSURL* url = [NSURL URLWithString:avFile.url];
        UIImageView* imageView = [UIImageView new];
        [imageView setImageWithURL:url options:YYWebImageOptionUseNSURLCache];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NIViewBorderRadius(cell.contentView, 2, [UIColor purpleColor].CGColor)
        
        //给item添加点击事件
        cell.indexPath = indexPath;
        WEAKSELF;
        __weak typeof(cell) weakCell = cell;
        cell.itemClickedBlock = ^(NSIndexPath *indexPath) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"【%ld,%ld】",(long)indexPath.section,(long)indexPath.item]];
            if (self.mulArray.count>0) {
                UIView *fromView = nil;
                NSMutableArray *items = [NSMutableArray new];
                for (NSUInteger i = 0, max = weakSelf.mulArray.count; i < max; i++) {
                    AVFile* avFile = weakSelf.mulArray[indexPath.item];
                    NSURL* url = [NSURL URLWithString:avFile.url];
                    UIImageView* imageView = [UIImageView new];
                    [imageView setImageWithURL:url options:YYWebImageOptionUseNSURLCache];
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [weakCell.contentView addSubview:imageView];
                    [imageView makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakCell.contentView);
                    }];
                    UIView *imgView = weakCell.contentView;
                    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                    
                    item.thumbView = imgView;
                    item.largeImageURL = url;
                    item.largeImageSize = CGSizeMake(kScreenWidth, kScreenHeight);
                    [items addObject:item];
                    if (i == indexPath.item) {
                        fromView = imageView;
                    }
                }
                
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
            }
        };
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-16)/2, (kScreenWidth-16)*1.5/2);//这里计算有误差，so 多减了1;
}
//设置section header大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 0?CGSizeMake(kScreenWidth,30):CGSizeMake(kScreenWidth, 35);
}
// 设置item间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
// 设置行间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
/**
 * Section的上下左右边距--UIEdgeInsetsMake(上, 左, 下, 右);逆时针
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark - Setters & Getters
-(CustomeCollectionViewLayout *)flowLayout{
    if (!_flowLayout) {
        //初始化UICollectionViewFlowLayout，设置集合视图滑动方向。
        _flowLayout = [[CustomeCollectionViewLayout alloc] init];
        //_flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直方向滚动
        /*
         // 通过属性设值。
         _flowLayout.itemSize = CGSizeMake(153, 128);
         _flowLayout.footerReferenceSize = CGSizeMake(35, 35);
         _flowLayout.minimumLineSpacing = 20;
         _flowLayout.minimumInteritemSpacing = 20;
         _flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
         */
    }
    return _flowLayout;
}
/**collectionView懒加载*/
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        //设置集合视图内容区域、layout、背景颜色。
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

/**
 数据源懒加载
 */
-(NSMutableArray *)mulArray{
    if (!_mulArray) {
        _mulArray = [NSMutableArray array];
    }
    return _mulArray;
}

@end
