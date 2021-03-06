//
//  PlaceAroundTableView.h
//  GDMapPlaceAroundDemo
//
//  Created by Mr.JJ on 16/6/14.
//  Copyright © 2016年 Mr.JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol MapPoiTableViewDelegate <NSObject>

@optional
// 加载更多列表数据
- (void)loadMorePOI;
// 将地图中心移到所选的POI位置上
- (void)setMapCenterWithPOI:(AMapPOI *)point isLocateImageShouldChange:(BOOL)isLocateImageShouldChange;
// 加载完成设置发送按钮可点击
- (void)setSendButtonEnabledAfterLoadFinished;
// 设置当前位置所在城市
- (void)setCurrentCity:(NSString *)city;

//返回选择
- (void)backviewWithpossCode :(NSString  *)possCode ;

@end

@interface MapPoiTableView : UIView <UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

@property (nonatomic, weak) id<MapPoiTableViewDelegate> delegate;
// 选中的POI点
@property (nonatomic, strong) AMapPOI *selectedPoi;

@property (nonatomic, copy) NSString *poiName;//地区名
@property (nonatomic, copy) NSString *poiaddress;//具体地址
@property (nonatomic, copy) NSString *postcode;//邮编

@end
