//
//  DDCity.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "DDCity.h"

@implementation DDCity
- (instancetype) copyWithZone:(NSZone *)zone {
    DDCity *city = [[DDCity allocWithZone:zone] init];
    NSLog(@"没有我copyWithZone你自定义对象就不能copy");
    //新增下面两行代码
    city.cityName = self.cityName;
    city.cityLocation = self.cityLocation;
    return city;
}
- (instancetype) mutableCopyWithZone:(NSZone *)zone {
    DDCity *city = [[DDCity allocWithZone:zone] init];
    NSLog(@"没有我mutableCopyWithZone你自定义对象就不能MCopy");
    //新增下面两行代码
    city.cityName = self.cityName;
    city.cityLocation = self.cityLocation;
    return city;
}
@end
