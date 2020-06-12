//
//  JRCountTextField.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "JRCountTextField.h"

@interface JRCountTextField()<UITextFieldDelegate>
@property (nonatomic,assign) BOOL isHaveDian;

@end

@implementation JRCountTextField
// 代码加载
-(instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

// xib加载
- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            // 如果第一个输入的是0，那么第二个必须输入小数点
            if([textField.text length] == 1){
                if(!(single == '.') && [[textField.text substringToIndex:1] isEqualToString:@"0"]) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    return YES;
}
@end
