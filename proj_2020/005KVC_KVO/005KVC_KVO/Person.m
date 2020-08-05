//
//  Person.m
//  005KVC_KVO
//
//  Created by nixs on 2020/8/4.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person.h"

@implementation Person
+ (BOOL)accessInstanceVariablesDirectly{
    return NO;
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    if ([key isEqualToString:@"_name"]) {
        return NO;
    }
    return NO;
}

@end
