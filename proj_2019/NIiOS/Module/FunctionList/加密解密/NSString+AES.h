//
//  NSString+AES.h
//  NIiOS
//
//  Created by nixs on 2018/12/14.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;

@end

