//
//  NIMapCoordinateManager.m
//  NIiOS
//
//  Created by nixs on 2019/5/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NIMapCoordinateManager.h"

@implementation NIMapCoordinateManager
+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)clean {
    [NIMapCoordinateManager shared].locationManager = nil;
}

-(void)setLocationManager:(AMapLocationManager *)locationManager{
    _locationManager = locationManager;
}
+ (void)getCoordinateWithAMapLocationManager:(AMapLocationManager*)locationManager
                                   ReGeocode:(BOOL)reGeocode
                        mapCoordinateHandler:(MapCoordinateHandler)ResultAndCoordinate{
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [locationManager requestLocationWithReGeocode:reGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error){
                ResultAndCoordinate(NO,0,0);
            }
            if (regeocode){
                double latitude = location.coordinate.latitude;
                double longitude = location.coordinate.longitude;
                ResultAndCoordinate(YES,latitude,longitude);
            }
    }];
}
@end
