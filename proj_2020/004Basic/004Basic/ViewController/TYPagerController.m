//
//  TYPagerController.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "TYPagerController.h"

@interface TYPagerController ()<UIScrollViewDelegate>{
    //实例变量
    NSInteger _countOfControllers;
    BOOL _needLayoutContentView;
    CGFloat _preOffsetX;
    float _heightInMeters;
    
    struct{
        unsigned int transitionFromIndexToIndex :1;
        unsigned int transitionFromIndexToIndexProgress :1;
    }_delegateFlags;
    
    struct {
        unsigned int transitionFromIndexToIndex :1;
        unsigned int transitionFromIndexToIndexProgress :1;
    }_methodFlags;
}

@property(nonatomic,weak) id nameDelegate;

@end

@implementation TYPagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"TYPagerController";
}

//一个例子
//实现getter
- (float)heightInMeters{
    return _heightInMeters;
}
//实现setter
- (float)setHeightInMeters:(float)h{
    _heightInMeters = h;
    return _heightInMeters;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
