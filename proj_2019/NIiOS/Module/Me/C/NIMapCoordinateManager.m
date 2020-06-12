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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString* errorMsg = [self getErrorMsgWithErrorCode:error.code];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ResultAndCoordinate(NO,0,0,[NSString isEmptyCheckString:errorMsg]);
                });
            });
        }
        if (regeocode){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                double latitude = location.coordinate.latitude;
                double longitude = location.coordinate.longitude;
                dispatch_async(dispatch_get_main_queue(), ^{
                    ResultAndCoordinate(YES,latitude,longitude,@"");
                });
            });
        }
    }];
}
+(NSString*)getErrorMsgWithErrorCode:(NSInteger)errorCode{
    NSString* errorMsg = @"";
    switch (errorCode) {
        case 2:{
            errorMsg = [NSString stringWithFormat:@"[2]定位错误，系统定位发生错误，具体错误原因请参考返回的NSError的描述，多是因为权限或网络问题。"];
            break;
        }
        case 3:{
            errorMsg = [NSString stringWithFormat:@"[3]逆地理错，误获取逆地理编码发生错误，如果出现该问题，您可以通过工单系统反馈给我们。"];
            break;
        }
        case 4:{
            errorMsg = [NSString stringWithFormat:@"[4]访问超时，网络情况差，请稍候再试"];
            break;
        }
        case 5:{
            errorMsg = [NSString stringWithFormat:@"[5]单次定位取消，取消了单次定位的消息"];
            break;
        }
        case 6:{
            errorMsg = [NSString stringWithFormat:@"[6]找不到主机，服务异常SDK找不到主机，请稍后再试"];
            break;
        }
        case 7:{
            errorMsg = [NSString stringWithFormat:@"[7]URL异常URL，可能已被篡改，请检查程序的安全性"];
            break;
        }
        case 8:{
            errorMsg = [NSString stringWithFormat:@"[8]连接异常，网络异常，无法联网"];
            break;
        }
        case 9:{
            errorMsg = [NSString stringWithFormat:@"[9]服务器连接失败，传输链路出现问题，请检查您的host是否正常"];
            break;
        }
        case 10:{
            errorMsg = [NSString stringWithFormat:@"[10]地理围栏错误，地理围栏监测出现异常，请注销掉围栏重新注册围栏使用"];
            break;
        }
        default:{
            errorMsg = [NSString stringWithFormat:@"[unknow]未知异常"];
            break;
        }
    }
    return errorMsg;
}
@end
