//
//  Game.m
//  runtime002
//
//  Created by ai-nixs on 2020/7/19.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Game.h"

@implementation Game

- (void)Play{
    NSLog(@"the game is play");
}

/// 第一步 实例方法专用 方法解析
/// @param sel <#sel description#>
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//    NSLog(@"%@",NSStringFromSelector(sel));
//    if (sel == @selector(DoThings:Num:)) {
//        class_addMethod([self class], self, (IMP)MyMethod, @"v%@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:<#sel#>];
//}

/// 第二步 如果第一步未处理，那么让别的对象去处理这个方法
/// @param aSelector <#aSelector description#>
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"DoThings:Num:"]) {
        return [[Game alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/// 第三步 如果前两步未处理，这是最后处理的机会将目标函数以其他形式执行
/// @param aSelector <#aSelector description#>
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *SelStr = NSStringFromSelector(aSelector);
    if ([SelStr isEqualToString:@"DoThings:Num:"]) {
        [NSMethodSignature signatureWithObjCTypes:@"v%@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //改变消息接受者对象
    [anInvocation invokeWithTarget:[[Game alloc]init]];
    //改变消息的SEL
    anInvocation.selector = @selector(flyGame);
    [anInvocation invokeWithTarget:self];
}
- (void)flyGame{
    NSLog(@"我要飞翔追逐梦想！");
}

/// 作为找不到函数实现的最后一步，NSObject实现这函数只有一个功能，就是抛出异常
/// 虽然理论上可以重载这个函数实现保证不抛出异常(不调用super实现)，但是苹果文档着重提出“一定不能让这个函数就这么结束，必须抛出异常”
/// @param aSelector <#aSelector description#>
- (void)doesNotRecognizeSelector:(SEL)aSelector{
    
}
@end
