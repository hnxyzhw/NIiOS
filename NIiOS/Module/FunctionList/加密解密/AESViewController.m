
//
//  AESViewController.m
//  NIiOS
//
//  Created by nixs on 2018/12/13.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "AESViewController.h"
#import "NSString+AES.h"

@interface AESViewController ()
@property(nonatomic,strong) YYTextView *yyTextView;
@end

@implementation AESViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AES加密、解密";
    
    
    NSString *password = @"12.23";
    
    NSString *encryptStr = [password aci_encryptWithAES];
    NSLog(@"加密后:%@", encryptStr);
    
    NSString *decryptStr = [encryptStr aci_decryptWithAES];
    NSLog(@"解密后:%@", decryptStr);
    
    NSString* urlEncodeStr = [self urlEncodeStr:encryptStr];
    NSLog(@"URLEncode后:%@", urlEncodeStr);
    
    self.yyTextView = [YYTextView new];
    self.yyTextView.text = self.labDes;
    [self.view addSubview:self.yyTextView];
    [self.yyTextView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-5);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-5);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    
/**
   （一）对称加密（Symmetric Cryptography）对称加密是最快速、最简单的一种加密方式，加密（encryption）与解密（decryption）用的是同样的密钥（secret key）,这种方法在密码学中叫做对称加密算法。对称加密有很多种算法，由于它效率很高，所以被广泛使用在很多加密协议的核心当中。\n 对称加密通常使用的是相对较小的密钥，一般小于256 bit。因为密钥越大，加密越强，但加密与解密的过程越慢。如果你只用1 bit来做这个密钥，那黑客们可以先试着用0来解密，不行的话就再用1解；但如果你的密钥有1 MB大，黑客们可能永远也无法破解，但加密和解密的过程要花费很长的时间。密钥的大小既要照顾到安全性，也要照顾到效率，是一个trade-off。\n   2000年10月2日，美国国家标准与技术研究所（NIST--American National Institute of Standards and Technology）选择了Rijndael算法作为新的高级加密标准（AES--Advanced Encryption Standard）。.NET中包含了Rijndael算法，类名叫RijndaelManaged，下面举个例子。\n   对称加密的一大缺点是密钥的管理与分配，换句话说，如何把密钥发送到需要解密你的消息的人的手里是一个问题。在发送密钥的过程中，密钥有很大的风险会被黑客们拦截。现实中通常的做法是将对称加密的密钥进行非对称加密，然后传送给需要它的人。\n(二）非对称加密（Asymmetric Cryptography）1976年，美国学者Dime和Henman为解决信息公开传送和密钥管理问题，提出一种新的密钥交换协议，允许在不安全的媒体上的通讯双方交换信息，安全地达成一致的密钥，这就是“公开密钥系统”。相对于“对称加密算法”这种方法也叫做“非对称加密算法”。\n   非对称加密为数据的加密与解密提供了一个非常安全的方法，它使用了一对密钥，公钥（public key）和私钥（private key）。私钥只能由一方安全保管，不能外泄，而公钥则可以发给任何请求它的人。非对称加密使用这对密钥中的一个进行加密，而解密则需要另一个密钥。比如，你向银行请求公钥，银行将公钥发给你，你使用公钥对消息加密，那么只有私钥的持有人--银行才能对你的消息解密。与对称加密不同的是，银行不需要将私钥通过网络发送出去，因此安全性大大提高。\n   目前最常用的非对称加密算法是RSA算法，是Rivest, Shamir, 和Adleman于1978年发明，他们那时都是在MIT。.NET中也有RSA算法，请看下面的例子：\n   虽然非对称加密很安全，但是和对称加密比起来，它非常的慢，所以我们还是要用对称加密来传送消息，但对称加密所使用的密钥我们可以通过非对称加密的方式发送出去。为了解释这个过程，请看下面的例子：\n   （1） Alice需要在银行的网站做一笔交易，她的浏览器首先生成了一个随机数作为对称密钥。\n   （2） Alice的浏览器向银行的网站请求公钥。\n   （3） 银行将公钥发送给Alice。\n   （4） Alice的浏览器使用银行的公钥将自己的对称密钥加密。\n   （5） Alice的浏览器将加密后的对称密钥发送给银行。\n   （6） 银行使用私钥解密得到Alice浏览器的对称密钥。\n   （7） Alice与银行可以使用对称密钥来对沟通的内容进行加密与解密了。\n   （三）总结\n   （1） 对称加密加密与解密使用的是同样的密钥，所以速度快，但由于需要将密钥在网络传输，所以安全性不高。\n   （2） 非对称加密使用了一对密钥，公钥与私钥，所以安全性高，但加密与解密速度慢。\n   （3） 解决的办法是将对称加密的密钥使用非对称加密的公钥进行加密，然后发送出去，接收方使用私钥进行解密得到对称加密的密钥，然后双方可以使用对称加密来进行沟通。
 */
}

/**
 *  URLEncode
 */
- (NSString *)urlEncodeStr:(NSString *)input{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return upSign;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedStringWithEncodedStr:(NSString *)encodedString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

//作者：你的小福蝶
//链接：https://www.jianshu.com/p/65d840504fde
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。





@end
