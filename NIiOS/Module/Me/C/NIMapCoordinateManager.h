//
//  NIMapCoordinateManager.h
//  NIiOS
//
//  Created by nixs on 2019/5/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//单次定位
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void(^MapCoordinateHandler)(bool resultCode,double latitude,double longitude);

NS_ASSUME_NONNULL_BEGIN

@interface NIMapCoordinateManager : NSObject
@property(nonatomic,strong) AMapLocationManager *locationManager;

+ (instancetype)shared;

+ (void)clean;

+ (void)getCoordinateWithAMapLocationManager:(AMapLocationManager*)locationManager
                ReGeocode:(BOOL)reGeocode
            mapCoordinateHandler:(MapCoordinateHandler)ResultAndCoordinate;

@end

NS_ASSUME_NONNULL_END
