//
//  HomeModel.m
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import "HomeModel.h"
@implementation ItemModel

@end


@implementation HomeModel
-(NSMutableArray<ItemModel *> *)item{
    if (!_item) {
        _item = [NSMutableArray array];
    }
    return _item;
}
@end
