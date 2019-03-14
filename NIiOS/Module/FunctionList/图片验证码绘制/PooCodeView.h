//
//  PooCodeView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/12/7.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PooCodeView : UIView
@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;
-(void)changeCode;

/**
 改变Code码，codeStr 回传
 */
@property (nonatomic,copy) void(^changeCodeBlock)(NSString* codeStr);
@end
