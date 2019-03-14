//
//  Programmer3.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/21.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "Programmer3.h"
#import "Artist.h"
#import "Singer.h"

@implementation Programmer3

/**
 通过消息转发实现多继承
 */
-(id)forwardingTargetForSelector:(SEL)aSelector{
    Artist* artist = [[Artist alloc] init];
    Singer* singer = [[Singer alloc] init];
    if ([artist respondsToSelector:aSelector]) {
        return artist;
    }
    if ([singer respondsToSelector:aSelector]) {
        return singer;
    }
    return nil;
}


@end
