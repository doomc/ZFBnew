//
//  AppDelegate+Location.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
/**
 *  声明block,传递经纬度、反编码、定位是否成功、显示框
 */
typedef void (^LocationPosition)(CLLocation *currentLocation,AMapLocationReGeocode *regeocode,BOOL isLocationSuccess);

@interface AppDelegate (Location)



@property (copy,nonatomic)LocationPosition locationBlock;          //定位到位置的block
@property (strong,nonatomic)AMapLocationManager *locationManager;  //管理者

//启动定位服务
-(void)startLocation;

//接收位置block
-(void)receiveLocationBlock:(LocationPosition)block;
@end
