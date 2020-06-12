//
//  NIUICollectionViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//
//UICollectionView学习：详细博文：https://github.com/pro648/tips/wiki/UICollectionView及其新功能drag-and-drop

#import "NIUICollectionViewController.h"
#import "CollectionReusableView.h"//自定义头/尾视图
#import "CollectionViewCell.h"//自定义UICollectionViewCell
#import "SimpleModel.h"//数据源

@interface NIUICollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDragDelegate,UICollectionViewDropDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) SimpleModel *simpleModel;
@end

static NSString * const cellIdentifier = @"cellIdentifier";
static NSString * const headerIdentifier = @"headerIdentifier";
static NSString * const footerIdentifier = @"footerIdentifier";

@implementation NIUICollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UICollectionView学习";
    self.view.backgroundColor = RGBACOLOR(129, 151, 206, 0.8);
    //添加collectionView to self.view
    [self.view addSubview:self.collectionView];
    //Masnory布局
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
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
    
    //为CollectionView添加长按手势
//    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reorderCollectionView:)];
//    [self.collectionView addGestureRecognizer:longPressGesture];
    
    //开启拖放手势、设置代理
    self.collectionView.dragInteractionEnabled = YES;
    self.collectionView.dragDelegate = self;
    self.collectionView.dropDelegate = self;
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.simpleModel.model.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.simpleModel.model[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //设置imageView图片、label文字
    NSString* imageName = [self.simpleModel.model[indexPath.section] objectAtIndex:indexPath.item];
    cell.imageViewHeader.image = [UIImage imageNamed:imageName];
    NSString* labText = [NSString stringWithFormat:@"【%li,%@】",indexPath.section,imageName];
    cell.labDes.text = labText;
    NIViewBorderRadius(cell.contentView, 2, [UIColor purpleColor].CGColor)
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionReusableView* reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //设置Header内容
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        //resuableView.labSectionHeader.textAlignment = NSTextAlignmentCenter;
        reusableView.labSectionHeader.text = [NSString stringWithFormat:@"Section %li",indexPath.section];
        reusableView.backgroundColor = RGBACOLOR(240, 146, 56, 0.8);
        reusableView.labSectionHeader.textColor = [UIColor blackColor];
    }else{
        //设置Footer内容
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        reusableView.viewLeft.hidden = YES;
        reusableView.labSectionHeader.textAlignment = NSTextAlignmentNatural;
        //reusableView.labSectionHeader.text = [NSString stringWithFormat:@"Section %li have %li items",indexPath.section,[collectionView numberOfItemsInSection:indexPath.section]];
        //或者如下方式
        reusableView.labSectionHeader.text = [NSString stringWithFormat:@"Section %li have %li items",indexPath.section,[self.simpleModel.model[indexPath.section] count]];
        reusableView.backgroundColor = RGBACOLOR(74, 164, 238, 0.8);
        reusableView.labSectionHeader.textColor = [UIColor blackColor];
    }
    return reusableView;
}

//是否允许移动item
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//更新数据源
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString* sourceObject = [self.simpleModel.model[sourceIndexPath.section]objectAtIndex:sourceIndexPath.item];
    [self.simpleModel.model[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
    [self.simpleModel.model[destinationIndexPath.section] insertObject:sourceObject atIndex:destinationIndexPath.item];
    //重新加载当前显示的item
    //[collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
    //或者如下方式
    [collectionView reloadData];
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
//设置section footer大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 30);
}
// 设置item间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
// 设置行间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//设置页边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - 长按手势响应方法
//- (void)reorderCollectionView:(UILongPressGestureRecognizer *)longPressGesture {
//    switch (longPressGesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            //手势开始
//            CGPoint touchPoint = [longPressGesture locationInView:self.collectionView];
//            NSIndexPath* selectedIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
//            if (selectedIndexPath) {
//                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
//            }
//            break;
//        }
//        case UIGestureRecognizerStateChanged:{
//            //手势变化
//            CGPoint touchPoint = [longPressGesture locationInView:self.collectionView];
//            [self.collectionView updateInteractiveMovementTargetPosition:touchPoint];
//            break;
//        }
//        case UIGestureRecognizerStateEnded:{
//            //手势结束
//            [self.collectionView endInteractiveMovement];
//            break;
//        }
//        default:{
//            [self.collectionView cancelInteractiveMovement];
//            break;
//        }
//    }
//}
#pragma mark-UICollectionViewDragDelegate
//拖动item.
- (NSArray <UIDragItem *>*)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSString *imageName = [self.simpleModel.model[indexPath.section] objectAtIndex:indexPath.item];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:imageName];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = imageName;
    return @[dragItem];
}
//设置拖动预览信息
-(UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath{
    //预览图为圆角,背景色为clearColor;
    UIDragPreviewParameters* previewParameters = [[UIDragPreviewParameters alloc] init];
    CollectionViewCell* cell = (CollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:5];
    previewParameters.backgroundColor = [UIColor clearColor];
    return previewParameters;
}
#pragma mark - UICollectionViewDropDelegate
//是否接收拖动的item
-(BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session{
    return [session canLoadObjectsOfClass:[NSString class]];
}
// 拖动过程中不断反馈item位置。
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UICollectionViewDropProposal *dropProposal;
    if (session.localDragSession) {
        // 拖动手势源自同一app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        // 拖动手势源自其它app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return dropProposal;
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    // 如果coordinator.destinationIndexPath存在，直接返回；如果不存在，则返回（0，0)位置。
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath ? coordinator.destinationIndexPath : [NSIndexPath indexPathForItem:0 inSection:0];
    
    // 在collectionView内，重新排序时只能拖动一个cell。
    if (coordinator.items.count == 1 && coordinator.items.firstObject.sourceIndexPath) {
        NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
        
        // 将多个操作合并为一个动画。
        [collectionView performBatchUpdates:^{
            // 将拖动内容从数据源删除，插入到新的位置。
            NSString *imageName = coordinator.items.firstObject.dragItem.localObject;
            [self.simpleModel.model[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
            [self.simpleModel.model[destinationIndexPath.section] insertObject:imageName atIndex:destinationIndexPath.item];
            
            // 更新collectionView。
            [collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        } completion:nil];
        
        // 以动画形式移动cell。
        [coordinator dropItem:coordinator.items.firstObject.dragItem toItemAtIndexPath:destinationIndexPath];
    }
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
        //设置集合视图内容区域、layout、北京颜色。
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
@end
