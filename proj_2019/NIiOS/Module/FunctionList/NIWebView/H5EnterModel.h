//
//  H5EnterModel.h
//  NIiOS
//
//  Created by ai-nixs on 2018/12/3.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5EnterModel : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *detailTitle;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSDictionary *cookie;
@property(nonatomic, assign) NSInteger type;

@end
