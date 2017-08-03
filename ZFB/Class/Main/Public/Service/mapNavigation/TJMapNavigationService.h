//
//  TJMapNavigationService.h
//  iOSTJUserSide
//
//  Created by 林经纬 on 2017/8/3.
//  Copyright © 2017年 林经纬. All rights reserved.
//

#import "CLLocation+MPLocation.h"
#import <MapKit/MapKit.h>

/**
 坐标类型

 - LocationType_Mars: 火星坐标
 - LocationType_Baidu: 百度坐标
 */
typedef NS_ENUM(NSInteger, LocationType){
    LocationType_Mars,
    LocationType_Baidu
};

@interface TJMapNavigationService : NSObject


/**
 初始化地图导航服务

 @param startLat 开始位置纬度
 @param startLot 开始位置经度
 @param endtLat 目标位置纬度
 @param endLot 目标位置经度
 @param endAddress 目标地址名称
 @param locationType 坐标类型
 */
-(instancetype)initWithStartLatitude:(CGFloat)startLat
                      startLongitude:(CGFloat)startLot
                         endLatitude:(CGFloat)endtLat
                        endLongitude:(CGFloat)endLot
                          endAddress:(NSString *)endAddress
                        locationType:(LocationType)locationType;


/**
 开始导航
 */
-(void)showAlert;
@end
