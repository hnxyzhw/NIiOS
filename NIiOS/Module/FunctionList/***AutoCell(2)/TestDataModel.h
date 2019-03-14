//
//  TestDataModel.h
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestDataModel : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSAttributedString *attributeTitle;
@property (nonatomic, strong) NSAttributedString *attributeTime;
@property (nonatomic, strong) NSAttributedString *attributeContent;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float textHeight;
@end

NS_ASSUME_NONNULL_END
