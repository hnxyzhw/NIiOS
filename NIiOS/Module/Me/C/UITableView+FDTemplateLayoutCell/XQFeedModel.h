//
//  XQFeedModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQFeedModel : NSObject
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *imageName;
@property (copy, nonatomic) NSString *time;
/**
 是否展开
 */
@property(nonatomic,assign) BOOL isOpening;

+ (instancetype) feedWithDictionary:(NSDictionary *) dictionary;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;
@end

NS_ASSUME_NONNULL_END
