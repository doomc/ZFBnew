//
//  TJMapNavigationService.m
//  iOSTJUserSide
//
//  Created by 林经纬 on 2017/8/3.
//  Copyright © 2017年 林经纬. All rights reserved.
//

#import "TJMapNavigationService.h"
#import "UIViewController+Unitil.h"

static NSString* const baiduMap = @"百度地图";
static NSString* const iosaMap = @"高德地图";
static NSString* const appleMap = @"苹果自带地图";
static NSString* const sdkMap = @"内置高德地图";


@interface TJMapNavigationService ()

@property (nonatomic, assign) CGFloat startLat;  //开始位置纬度
@property (nonatomic, assign) CGFloat startLot;  //开始位置经度
@property (nonatomic, assign) CGFloat endLat;  //目标位置纬度
@property (nonatomic, assign) CGFloat endLot;  //目标位置经度
@property (nonatomic, copy) NSString *endAddress;  //目标地址名称
@property (nonatomic, assign) LocationType loactionType;  //源坐标系类型

//源坐标
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;

//火星坐标
@property (nonatomic, strong) CLLocation *marsStartLocation;
@property (nonatomic, strong) CLLocation *marsEndLocation;

@property (nonatomic, assign) CGFloat marsStartLat;
@property (nonatomic, assign) CGFloat marsStartLot;
@property (nonatomic, assign) CGFloat marsEndLat;
@property (nonatomic, assign) CGFloat marsEndLot;

//百度坐标
@property (nonatomic, strong) CLLocation *baiduStartLocation;
@property (nonatomic, strong) CLLocation *baiduEndLocation;

@property (nonatomic, assign) CGFloat baiduStartLat;
@property (nonatomic, assign) CGFloat baiduStartLot;
@property (nonatomic, assign) CGFloat baiduEndLat;
@property (nonatomic, assign) CGFloat baiduEndLot;

@property (nonatomic, strong) NSMutableArray *mapNameArray;
@end
@implementation TJMapNavigationService

-(instancetype)initWithStartLatitude:(CGFloat)startLat startLongitude:(CGFloat)startLot endLatitude:(CGFloat)endtLat endLongitude:(CGFloat)endLot endAddress:(NSString *)endAddress locationType:(LocationType)locationType {
    
    self = [super init];
    if (self) {
        
        _startLat = startLat;
        _startLot = startLot;
        _endLat = endtLat;
        _endLot = endLot;
        _endAddress = endAddress;
        _loactionType = locationType;
    }
    return self;
}
#pragma mark - 坐标转换
-(CLLocation *)startLocation {
    if (!_startLocation) {
        _startLocation = [[CLLocation alloc] initWithLatitude:_startLat longitude:_startLot];
    }
    return _startLocation;
}
-(CLLocation *)endLocation {
    if (!_endLocation) {
        _endLocation = [[CLLocation alloc] initWithLatitude:_endLat longitude:_endLot];
    }
    return _endLocation;
}
-(CLLocation *)marsStartLocation {
    
    if (!_marsStartLocation) {
        if (_loactionType == LocationType_Baidu) {
            _marsStartLocation = [self.startLocation locationMarsFromBaidu];
        }else {
            _marsStartLocation = self.startLocation;
        }
    }
    return _marsStartLocation;
}
-(CLLocation *)marsEndLocation {
    
    if (!_marsEndLocation) {
        if (_loactionType == LocationType_Baidu) {
            _marsEndLocation = [self.endLocation locationMarsFromBaidu];
        }else {
            _marsEndLocation = self.endLocation;
        }
    }
    return _marsEndLocation;
}
-(CLLocation *)baiduStartLocation {
    if (!_baiduStartLocation) {
        if (_loactionType == LocationType_Baidu) {
            _baiduStartLocation = self.startLocation;
        }else {
            _baiduStartLocation = [self.startLocation locationBaiduFromMars];
        }
    }
    return _baiduStartLocation;
}
-(CLLocation *)baiduEndLocation {
    if (!_baiduEndLocation) {
        if (_loactionType == LocationType_Baidu) {
            _baiduEndLocation = self.endLocation;
        }else {
            _baiduStartLocation = [self.endLocation locationBaiduFromMars];
        }
    }
    return _baiduEndLocation;
}

-(CGFloat)marsStartLat {
    
    return self.marsStartLocation.coordinate.latitude;
}
-(CGFloat)marsStartLot {
    
    return self.marsStartLocation.coordinate.longitude;
}
-(CGFloat)marsEndLat {

    return self.marsEndLocation.coordinate.latitude;
}
-(CGFloat)marsEndLot {
    
    return self.marsEndLocation.coordinate.longitude;
}
-(CGFloat)baiduStartLat {
    
    return self.baiduStartLocation.coordinate.latitude;
}
-(CGFloat)baiduStartLot {
    
    return self.baiduStartLocation.coordinate.longitude;
}
-(CGFloat)baiduEndLat {
    
    return self.baiduEndLocation.coordinate.latitude;
}
-(CGFloat)baiduEndLot {
    
    return self.baiduEndLocation.coordinate.longitude;
}
-(NSMutableArray *)mapNameArray {
    
    if (!_mapNameArray) {
        _mapNameArray = [NSMutableArray array];
        
        //苹果自带地图
        [_mapNameArray addObject:appleMap];
        
        
        //百度地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
             [_mapNameArray addObject:baiduMap];
        }
       
        //高德地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            [_mapNameArray addObject:iosaMap];
        }
    }
    return _mapNameArray;
}
#pragma mark - 地图导航跳转
//苹果自带地图
-(void)appleMapNav {
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.marsEndLat, self.marsEndLot);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    toLocation.name = _endAddress;
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}
//SDK(跳转自己SDKVC)
-(void)sdkMapNav {
 
}
//百度地图
-(void)baiduMapNav {
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving", self.baiduStartLat, self.baiduStartLot, self.baiduEndLat, self.baiduEndLot] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
}
//高德地图
-(void)iosaMapNav {
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0", self.marsStartLat, self.marsStartLot, @"我的位置", self.marsEndLat, self.marsEndLot,_endAddress]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
#pragma mark - 弹出选择提示
-(void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *mapNameStr in self.mapNameArray) {
        [alert addAction:[UIAlertAction actionWithTitle:mapNameStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([mapNameStr isEqualToString:appleMap]) {
                [self appleMapNav];
            }
            if ([mapNameStr isEqualToString:iosaMap]) {
                [self iosaMapNav];
            }
            if ([mapNameStr isEqualToString:baiduMap]) {
                [self baiduMapNav];
            }
            if ([mapNameStr isEqualToString:sdkMap]) {
                [self sdkMapNav];
            }
        }]];
    }
    [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    UIViewController *currentVC = [UIViewController getCurrentVC];
    [currentVC presentViewController:alert animated:YES completion:nil];
}
@end
