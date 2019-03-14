//
//  SelectedView.m
//  NIiOS
//
//  Created by nixs on 2019/2/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "SelectedView.h"
#import "SelCollectionViewCell.h"
#import "SelCollectionReusableView.h"

@interface SelectedView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong) NSMutableArray *mulSelNSIndexPathArray;//选定array NSIndexPath
@property(nonatomic,strong) NSMutableArray *mulSelItemTieleArray;//选定array itemTiele
@property(nonatomic,strong) NSString* str;//拼接结果字符串
@end

static NSString * const cellIdentifier = @"cellIdentifier";
static NSString * const headerIdentifier = @"headerIdentifier";

@implementation SelectedView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        //1.初始化imageView、label(一定记住如下取自定义Cell宽、高方式)
        //CGFloat cellWidth = self.bounds.size.width;
        //CGFloat cellHeight = self.bounds.size.height;
        
        //添加collectionView to self.view
        [self addSubview:self.collectionView];
        //Masnory布局
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(40*(3+2+1)+40*3);
        }];
        //frame布局
        //[self.collectionView setFrame:CGRectMake(0, 0, cellWidth, cellHeight-40)];
        
        //注册cell、headerView/footerView
        [self.collectionView registerClass:[SelCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self.collectionView registerClass:[SelCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        
        self.btnReview = [UIButton new];
        [self.btnReview setTitle:@"重置" forState:UIControlStateNormal];
        [self.btnReview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btnReview setBackgroundColor:[UIColor whiteColor]];
        [self.btnReview addTarget:self action:@selector(btnReviewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnReview];
        [self.btnReview makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(kScreenWidth/4);
            make.height.equalTo(49);
        }];
        self.btnOk = [UIButton new];
        [self.btnOk setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnOk setBackgroundColor:[UIColor redColor]];
        [self.btnOk addTarget:self action:@selector(btnOkClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnOk];
        [self.btnOk makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom);
            make.right.equalTo(self);
            make.width.equalTo(kScreenWidth*3/4);
            make.height.equalTo(49);
        }];
    }
    return self;
}
/**
 重置按钮点击事件
 */
-(void)btnReviewClicked:(UIButton*)btn{
    NSLog(@"----重置按钮点击事件------Result:%@",self.mulSelNSIndexPathArray);
    //清空索引(NSIndexPath)、清空数组
    //[self.collectionView reloadItemsAtIndexPaths:self.mulSelNSIndexPathArray];
    
    [self.mulSelNSIndexPathArray removeAllObjects];
    [self.mulSelItemTieleArray removeAllObjects];
    [self.collectionView reloadData];
    
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
}
/**
 确定按钮点击事件
 */
-(void)btnOkClicked:(UIButton*)btn{
    self.str = @"";
    WEAKSELF;
    [self.mulSelItemTieleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        weakSelf.str = [NSString stringWithFormat:@"%@、%@",weakSelf.str,obj];
    }];
    NSMutableString* mulStr = [NSMutableString stringWithString:self.str];
    if (mulStr.length>=2) {
        [self makeToast:[mulStr substringFromIndex:1] duration:3.0 position:CSToastPositionCenter];
    }
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mulArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mulArray[section] count];
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SelCollectionReusableView* reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //设置Header内容
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        reusableView.labSectionHeader.text = self.titleArray[indexPath.section];
    }
    return reusableView;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString* itemTitle = [self.mulArray[indexPath.section] objectAtIndex:indexPath.item];
    [cell.btnItem setTitle:itemTitle forState:UIControlStateNormal];
    
    //这个赋值一定要在这里赋值，要不item的自动重用机制会造成选定按钮随机跑了 2019年02月20日14:08:27
    cell.btnItem.selected = NO;
    [cell.btnItem setBackgroundColor:[UIColor clearColor]];
    
    //给item添加点击事件
    cell.indexPath = indexPath;
    cell.itemTitle = itemTitle;
    WEAKSELF;
    cell.itemClickedBlock = ^(NSIndexPath * _Nonnull indexPath, BOOL isSelected,NSString* itemTitle) {
        [weakSelf makeToast:[NSString stringWithFormat:@"【%ld,%ld】itemTitle:%@",(long)indexPath.section,(long)indexPath.item,itemTitle]];
        if (isSelected) {
            [weakSelf.mulSelNSIndexPathArray addObject:indexPath];
            [weakSelf.mulSelItemTieleArray addObject:itemTitle];//选定了哪些按钮
        }else{
            [weakSelf.mulSelNSIndexPathArray removeObject:indexPath];
            [weakSelf.mulSelItemTieleArray removeObject:itemTitle];//反选了哪些按钮
        }
        NSLog(@"----Block------Result:%@",weakSelf.mulSelItemTieleArray);
    };
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = self.bounds.size.width;
    return CGSizeMake((cellWidth-50)/4, 40);//这里计算有误差，so 多减了1;
}
//设置section header大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 0?CGSizeMake(kScreenWidth,30):CGSizeMake(kScreenWidth, 30);
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
    return UIEdgeInsetsMake(0, 10, 0, 10);
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
//        CGFloat cellWidth = self.bounds.size.width;
//        _flowLayout.itemSize = CGSizeMake((cellWidth-50)/4, 40);
//        _flowLayout.headerReferenceSize = CGSizeMake(cellWidth, 30);
//        _flowLayout.minimumInteritemSpacing = 10;
//        _flowLayout.minimumLineSpacing = 10;
//        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _flowLayout;
}
/**collectionView懒加载*/
-(UICollectionView*)collectionView{
    if (!_collectionView) {
        //设置集合视图内容区域、layout、背景颜色。
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
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
/**
 选定item数据集合
 */
-(NSMutableArray *)mulSelNSIndexPathArray{
    if (!_mulSelNSIndexPathArray) {
        _mulSelNSIndexPathArray = [NSMutableArray array];
    }
    return _mulSelNSIndexPathArray;
}
-(NSMutableArray *)mulSelItemTieleArray{
    if (!_mulSelItemTieleArray) {
        _mulSelItemTieleArray = [NSMutableArray array];
    }
    return _mulSelItemTieleArray;
}
@end
