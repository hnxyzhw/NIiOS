//
//  ViewController.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "TYPagerController.h"
#import "UIView+MBPHUD.h"
#import "DDCity.h"
#import <NITools-umbrella.h>

// 屏幕
#define kScreenWidth [UIScreen mainScreen].bounds.size.width     //屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height   //屏幕高度

@interface ViewController ()
@property(nonatomic,strong) UIView *viewTop;
@property(nonatomic,strong) UIButton *btnNext;

//@property (nonatomic,copy) NSString *str;
@property (nonatomic,strong) NSString *str;
//结论：被strong修饰以后只是强指针引用，并未改变地址，所以str的值会随着strM进行变化，二者的地址也是相同的。
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"首页";
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.btnNext];
    [self func_copy_006];
}

-(void)func_copy_006{
    NSMutableString *strM = [[NSMutableString alloc] initWithString:@"bestDay"];
    self.str = strM;
    [strM appendString:@"OfThisYear"];
    NSLog(@"str----%@---%p",self.str,self.str);
    NSLog(@"strM----%@---%p",strM,strM);
    
    
    
    ///理解深拷贝和完全拷贝
    //深复制，就是把原有对象内容直接克隆一份新的对象，但是这里有一个坑，就是深复制只是复制一层对象，而不是复制第二层或者更深层的对象。可能说的有点不好理解，下面看这个例子。
    //结果：大家可能会想，为什么深拷贝已经复制了对象，那么原对象为什么也跟着变？这里就是深拷贝和完全拷贝的原因，深拷贝只是拷贝了一层数组，但是里面的字符串没有拷贝，两个数组都是用的同一个地址的字符串，所以改变一个，原对象也发生了变化。可以做下面这样的修改。
    
    //***多一层复制
    //NSMutableArray *arrM2 = [[NSMutableArray alloc] initWithArray:arrM1 copyItems:YES];
    //结论：看这个结果，可以发现外层的深复制了，原对象和拷贝后的对象不是同一地址，再往里看一层都变化了，就没有深复制，也就是说在增加一层，NSMutableArray *arrM2 = [[NSMutableArray alloc] initWithArray:arrM1 copyItems:YES];这个方法不能管那么多层数了。采用归档和解档可以解决这个问题。
    
    //***完全复制
    //归档、解档
    //NSMutableArray *arrM3 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arrM2]];

//    作者：刀客传奇
//    链接：https://www.jianshu.com/p/4e5fde48fcda
//    来源：简书
//    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
}

/// 自定义对象
-(void)func_copy_005{
    DDCity *city = [[DDCity alloc] init];
    city.cityName = @"北京";
    city.cityLocation = @"中国";

    DDCity *cityCopy = [city copy];
    DDCity *cityMCopy = [city mutableCopy];
    
    NSLog(@"city---%@---%@",city.cityName,city.cityLocation);
    NSLog(@"cityCopy---%@---%@",cityCopy.cityName,cityCopy.cityLocation);
    NSLog(@"cityMCopy---%@---%@",cityMCopy.cityName,cityMCopy.cityLocation);

    NSLog(@"city---%@---%p---%@",city,city,[city class]);
    NSLog(@"cityCopy---%@---%p---%@",cityCopy,cityCopy,[cityCopy class]);
    NSLog(@"cityMCopy---%@---%p---%@",cityMCopy,cityMCopy,[cityMCopy class]);
    //结论：1）自定义对象copy和mutableCopy后的对象地址都不一样，均为深拷贝。2）拷贝后的对象属性cityName和cityLocation均为null，也就是说属性并未拷贝，
    //结论：通过增加对属性的赋值，新拷贝的对象就拥有了原对象的属性值。
}

////////////////////////////////////////////////////////////////////////NSDictionary 和 NSMutableDictionary的拷贝//////////////////////////////////////////////////////////////////////////////////////////
//结论：不可变字典NSDictionary，它的copy所得对象地址和原对象地址相同，是浅拷贝。而mutableCopy后的对象地址和原对象地址不一样，是深拷贝。
//结论：可变字典NSMutableDictionary，它的copy和mutableCopy出来的对象地址和原对象地址都不是一样的，是深拷贝。

////////////////////////////////////////////////////////////////////////NSArray 和 NSMutableArray的拷贝//////////////////////////////////////////////////////////////////////////////////////////
-(void)func_copy_004{
    NSArray *strArr1 = @[@"111", @"222"];
    NSMutableArray *strArrM = [NSMutableArray arrayWithArray:strArr1];
    //NSMutableArray *arrayInit = [[NSMutableArray alloc] init];
    NSArray *strArrMCopy = [strArrM copy];
    NSMutableArray *strArrMMutableCopy = [strArrM mutableCopy];
    NSLog(@"str---%@---%p----%@----",strArrM,strArrM,[strArrM class]);
    NSLog(@"strCopy---%@---%p----%@----",strArrMCopy,strArrMCopy,[strArrMCopy class]);
    NSLog(@"strMutableCopy---%@---%p----%@----",strArrMMutableCopy,strArrMMutableCopy,[strArrMMutableCopy class]);
    //结论：可变数组NSMutableArray，它的copy和mutableCopy所得对象地址和原对象地址都不相同，是深拷贝。
}
-(void)func_copy_003{
    NSArray *strArr = @[@"111", @"222"];
    NSArray *strArrCopy = [strArr copy];
    NSMutableArray *strArrMutableCopy = [strArr mutableCopy];
    NSLog(@"str---%@---%p----%@----",strArr,strArr,[strArr class]);
    NSLog(@"strCopy---%@---%p----%@----",strArrCopy,strArrCopy,[strArrCopy class]);
    NSLog(@"strMutableCopy---%@---%p----%@----",strArrMutableCopy,strArrMutableCopy,[strArrMutableCopy class]);
    //结论：不可变数组NSArray，它的copy所得对象地址和原对象地址相同，是浅拷贝。而mutableCopy后的对象地址和原对象地址不一样，是深拷贝。
}
////////////////////////////////////////////////////////////////////////NSString 和 NSMutableString的拷贝//////////////////////////////////////////////////////////////////////////////////////////
-(void)func_copy_002{
    NSMutableString *str =[NSMutableString stringWithString:@"虫儿不会飞"];
    NSString *strCopy = [str copy];
    NSMutableString *strMutableCopy = [str mutableCopy];
    NSLog(@"str---%@---%p----%@----",str,str,[str class]);
    NSLog(@"strCopy---%@---%p----%@----",strCopy,strCopy,[strCopy class]);
    NSLog(@"strMutableCopy---%@---%p----%@----",strMutableCopy,strMutableCopy,[strMutableCopy class]);
    //结论:变字符串NSMutableString,它的copy和mutableCopy出来的对象地址和原对象地址都不一样，是深拷贝；
}
-(void)func_copy_001{
    NSString *str = @"虫儿不会飞";
    NSString *strCopy = [str copy];
    NSMutableString *strMutableCopy = [str mutableCopy];
    NSLog(@"str---%@---%p----%@----",str,str,[str class]);
    NSLog(@"strCopy---%@---%p----%@----",strCopy,strCopy,[strCopy class]);
    NSLog(@"strMutableCopy---%@---%p----%@----",strMutableCopy,strMutableCopy,[strMutableCopy class]);
    //结论：不可变字符串NSString，它的copy出来的对象地址和原对象地址一样-是浅拷贝，而mutableCopy后的对象地址和原对象地址不一样，是深拷贝；
}

/// 页面跳转 没有用UINavigationController
-(void)nextPage{
    [self.view showHUDMessage:@"加载中..."];
    /**
     //[self presentViewController:[TYPagerController new] animated:YES completion:nil];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.view hideHUD];
         [self presentViewController:[TYPagerController new] animated:YES completion:nil];
     });
     */
    
     NIVersionManagerView *vmView = [[NIVersionManagerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
     vmView.desc = @"组件化就是将APP拆分成各个组件（或者说模块也行），同时解除这些模块之间的耦合，然后通过主工程将项目所需要的组件组合起来。这样组件化过后的项目就变成了很多小模块，如果新项目中有类似的需求，直接将模块引入稍作修改就能使用了。";
     //修改组件属性
     [vmView.btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [self.view addSubview:vmView];
     //组件按钮相应事件block
     vmView.btnOKBlock = ^{
         [self.view showHUDMessage:@"btnOKBlock"];
     };
     vmView.btnExitBlock = ^{
         [self.view showHUDMessage:@"btnExitBlock"];
     };
     
    
    /**
     NIPrivacyView* priView = [[NIPrivacyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
     [self.view addSubview:priView];
     priView.btnOKBlock = ^{
         [self.view showHUDMessage:@"btnOKBlock"];
     };
     priView.btnExitBlock = ^{
         [self.view showHUDMessage:@"btnExitBlock"];
     };
     priView.privacyBlock = ^{
       [self.view showHUDMessage:@"隐私详情"];
     };
     */
}
/// 懒加载
-(UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(20, self.viewTop.y+self.viewTop.height+5, kScreenWidth-40, 50)];
        [_btnNext setTitle:@"下一页" forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor redColor]];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}

-(UIView *)viewTop{
    if (!_viewTop) {
        // w:100,h:100 居中
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, self.labTitle.y+self.labTitle.height+1, 100, 100)];
        _viewTop.backgroundColor = [UIColor purpleColor];
    }
    return _viewTop;
}


@end
