//
//  HomeModel.h
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject
@property (nonatomic, strong) NSString *imageNameItem;
@property (nonatomic, strong) NSString *titleItem;
@property (nonatomic, strong) NSString *timeItem;
@property (nonatomic, strong) NSString *contentItem;

@property (nonatomic, strong) NSAttributedString *attributeTitle;
@property (nonatomic, strong) NSAttributedString *attributeTime;
@property (nonatomic, strong) NSAttributedString *attributeContent;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float textHeight;

@end


@interface HomeModel : NSObject
/**
 分组标题
 */
@property (nonatomic,strong) NSString *title;
/**
 分组内容item
 */
@property (nonatomic,strong) NSArray<NSString*> *body;

@property (nonatomic,strong) NSMutableArray<ItemModel*> *item;



@end

NS_ASSUME_NONNULL_END
