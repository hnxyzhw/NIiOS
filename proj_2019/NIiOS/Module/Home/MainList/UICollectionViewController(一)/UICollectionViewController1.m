
//
//  UICollectionViewController1.m
//  NIiOS
//
//  Created by nixs on 2019/2/18.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "UICollectionViewController1.h"
#import "CollectionReusableView.h"//自定义头/尾视图
#import "CollectionViewCell.h"//自定义UICollectionViewCell
#import "SimpleModel.h"//数据源

@interface UICollectionViewController1 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) SimpleModel *simpleModel;
@end

static NSString * const cellIdentifier = @"cellIdentifier";
static NSString * const headerIdentifier = @"headerIdentifier";
static NSString * const footerIdentifier = @"footerIdentifier";

@implementation UICollectionViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    //参考：https://www.cnblogs.com/ludashi/p/4791826.html
    self.navigationItem.title = @"UICollectionViewController(一) -- Ready Your CollectionViewController";
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
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    //初始化simpleModel
    self.simpleModel = [[SimpleModel alloc] init];
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.simpleModel.model.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.simpleModel.model[section] count];
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
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //设置imageView图片、lab文字
    NSString* imageName = [self.simpleModel.model[indexPath.section] objectAtIndex:indexPath.item];
    cell.imageViewHeader.image = [UIImage imageNamed:imageName];
    NSString* labText = [NSString stringWithFormat:@"【%li,%@】",indexPath.section,imageName];
    cell.labDes.text = labText;
    NIViewBorderRadius(cell.contentView, 2, [UIColor purpleColor].CGColor)
    
    //给item添加点击事件
    cell.indexPath = indexPath;
    WEAKSELF;
    cell.itemClickedBlock = ^(NSIndexPath *indexPath) {
        [weakSelf.view makeToast:[NSString stringWithFormat:@"【%ld,%ld】",(long)indexPath.section,(long)indexPath.item]];
    };
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-31)/3, (kScreenWidth-31)/3);//这里计算有误差，so 多减了1;
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
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        //初始化UICollectionViewFlowLayout，设置集合视图滑动方向。
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直方向滚动
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
@end
