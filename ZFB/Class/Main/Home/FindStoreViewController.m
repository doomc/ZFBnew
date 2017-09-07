

//
//  FindStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindStoreViewController.h"
#import "HP_LocationViewController.h"
#import "DetailStoreViewController.h"
#import "ZFAllStoreViewController.h"
//cell
#import "FindStoreCell.h"
//model
#import "HomeStoreListModel.h"
//map
#import <CoreLocation/CoreLocation.h>

 

static NSString *CellIdentifier = @"FindStoreCellid";

@interface FindStoreViewController ()<UITableViewDataSource,UITableViewDelegate ,CLLocationManagerDelegate,CYLTableViewPlaceHolderDelegate, WeChatStylePlaceHolderDelegate>
{
    NSString *currentCityAndStreet;//当前城市
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    NSInteger totalCount;//总条数
}
@property (strong,nonatomic) UITableView * home_tableView;
@property (strong,nonatomic) UIView * sectionView;
@property (nonatomic,strong) NSMutableArray * storeListArr;//数据源
@property (nonatomic,strong) UIButton * location_btn ;

//高德api
@property (nonatomic,strong) CLLocationManager * locationManager;

@end
@implementation FindStoreViewController

-(NSMutableArray *)storeListArr
{
    if (!_storeListArr) {
        _storeListArr = [NSMutableArray array];
    }
    return _storeListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initWithHome_Tableview];
    
    [self initInTerfaceView];
   
    //主队列+异步任务
    dispatch_queue_t queue = dispatch_get_main_queue();

    //刷新定位
    [self LocationMapManagerInit];
    
    dispatch_async(queue,^{
   
        
        NSLog(@"%@ ",[NSThread currentThread]);
            //定位成功后请求
        [self PostRequst];
        
    });

    [self setupRefresh];
    
}
#pragma mark -数据请求
-(void)headerRefresh {
    [super headerRefresh];
    [self PostRequst];
}
-(void)footerRefresh {
    [super footerRefresh];
    [self PostRequst];
}

-(UIButton *)location_btn
{
    if (!_location_btn) {
        _location_btn  = [UIButton buttonWithType:UIButtonTypeCustom];//定位按钮
        [_location_btn addTarget:self action:@selector(pushToLocationView:) forControlEvents:UIControlEventTouchUpInside];
        [_location_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
        
        UIFont * font = [UIFont systemFontOfSize:13];
        _location_btn.titleLabel.font = font ;
        [_location_btn setTitle:currentCityAndStreet forState:UIControlStateNormal];
        [_location_btn.titleLabel  sizeToFit];
        _location_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        _location_btn.frame = CGRectMake(25, 0, KScreenW - 60, 30);
#pragma mark - button内文字居左
        //  _location_btn.titleLabel.textAlignment = NSTextAlignmentLeft; 无效
        _location_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _location_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _location_btn;
}
-(void)initInTerfaceView{
    
    //    NSString * LoactionAddress = @"龙湖水晶国际 >";
    UIView * loc_view =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];//背景图
    UIView * bg_view =[[UIView alloc]initWithFrame:CGRectMake(15, 5, KScreenW-15-15, 30)];
    [loc_view addSubview:bg_view];
    
    bg_view.layer.borderWidth = 1.0;
    bg_view.layer.cornerRadius = 4.0;
    bg_view.layer.borderColor = HEXCOLOR(0xfa6d6a).CGColor;
    
    //定位icon
    UIImageView * icon_locationView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 18, 20) ];
    icon_locationView.image =  [UIImage imageNamed:@"location_find2"];
    
    [bg_view addSubview:self.location_btn];
    [bg_view addSubview: icon_locationView ];
    self.home_tableView.tableHeaderView = loc_view;
}


/**
 初始化home_tableView
 */
-(void)initWithHome_Tableview
{

    self.home_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH -49-64-44) style:UITableViewStylePlain];
    self.home_tableView.delegate = self;
    self.home_tableView.dataSource = self;
    [self.view addSubview:_home_tableView];
    self.home_tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.home_tableView registerNib:[UINib nibWithNibName:@"FindStoreCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    self.zfb_tableView = self.home_tableView;
}
-(UIView *)sectionView
{
    if (!_sectionView) {
        _sectionView =[[UIView alloc] initWithFrame:CGRectMake(30, 0,KScreenW, 40)];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 35)];
        _sectionView.backgroundColor = HEXCOLOR(0xffcccc);
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = @"附近门店";
        labelTitle.textColor = HEXCOLOR(0x363636);
        labelTitle.font =[ UIFont systemFontOfSize:14];
        [_sectionView addSubview:labelTitle];
        
        UIButton * more_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [more_btn addTarget:self action:@selector(more_btnAction:) forControlEvents:UIControlEventTouchUpInside];
        more_btn.frame =CGRectMake( KScreenW - 40 , 0, 40, 35);
        [more_btn setTitle:@"更多" forState:UIControlStateNormal];
        more_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [more_btn setTitleColor: HEXCOLOR(0xfa6d6a) forState:UIControlStateNormal];
        [_sectionView addSubview:more_btn];
        
        UIImageView * icon_locationView = [[UIImageView alloc]init ];//定位icon
        icon_locationView.frame =CGRectMake(15,5, 20, 25);
        icon_locationView.image = [UIImage imageNamed:@"location_find"];
        
        [_sectionView addSubview:icon_locationView];
        
    }
    return _sectionView;
}
#pragma mark - datasoruce  代理实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storeListArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        
        view = self.sectionView ;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    FindStoreCell *storeCell = [self.home_tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    storeCell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (self.storeListArr.count > 0) {
        
        Findgoodslist * listModel =  self.storeListArr[indexPath.row];
        storeCell.findgoodslist = listModel;
    }

    return storeCell;
    
}
#pragma tableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" section --- %ld ,row -----%ld",indexPath.section ,indexPath.row);    
    if (self.storeListArr.count > 0) {
        
        DetailStoreViewController * vc = [[DetailStoreViewController alloc]init];
        Findgoodslist * listModel = self.storeListArr[indexPath.row];
        vc.storeId =[NSString stringWithFormat:@"%ld",listModel.storeId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 更多门店
 
 @param sender  跳转到更多门店
 */
-(void)more_btnAction:(UIButton*)sender
{
    NSLog(@"更多门店");
    
    ZFAllStoreViewController * allVC =[[ ZFAllStoreViewController alloc]init];
    [self.navigationController pushViewController:allVC animated:YES];
}
/**
 定位
 @param sender 跳转到定位
 */
-(void)pushToLocationView:(UIButton *)sender
{
    HP_LocationViewController * locationVC =[[ HP_LocationViewController alloc]init];
    [self.navigationController pushViewController: locationVC animated:YES];
    
}
#pragma mark  - 定位当前
/**定位当前 */
-(void)LocationMapManagerInit
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 200;
        _locationManager.delegate = self;
        currentCityAndStreet = [NSString new];
        [_locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
    
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:@"center"];

}

#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];

    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    latitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    longitudestr = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    
    BBUserDefault.latitude = latitudestr;
    BBUserDefault.longitude = longitudestr;
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCityAndStreet = placeMark.locality;
            if (!currentCityAndStreet) {
                currentCityAndStreet = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",currentCityAndStreet);//当前的城市
            NSLog(@"%@",placeMark.subLocality);//当前的位置
            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            NSLog(@"%@",placeMark.name);//具体地址

            currentCityAndStreet = [NSString stringWithFormat:@"%@%@",placeMark.subLocality,placeMark.name];
            [self.location_btn setTitle:currentCityAndStreet forState:UIControlStateNormal];
            
        }
    }];
    

}

#pragma mark - 首页网络请求 getCmStoreInfo
-(void)PostRequst
{
    BBUserDefault.longitude = longitudestr;
    BBUserDefault.latitude = latitudestr;
    
 
    NSDictionary * parma = @{
 
                             @"longitude":longitudestr,//经度
                             @"latitude":latitudestr ,//纬度
                             @"pageSize":[NSNumber numberWithInteger:kPageCount],
                             @"pageIndex":[NSNumber numberWithInteger:self.currentPage],
                             @"businessType":@"",
                             @"payType":@"",
                             @"orderBydisc":@"",
                             @"orderbylikeNum":@"",
                             @"nearBydisc":@"",
                             @"sercahText":@"",
                             
                             };

    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {
 
        if ([response[@"resultCode"] intValue] == 0) {
            
            if (self.refreshType == RefreshTypeHeader) {
            
                if (self.storeListArr.count > 0) {
                    
                    [self.storeListArr  removeAllObjects];
                }
            }
            HomeStoreListModel * homeStore = [HomeStoreListModel mj_objectWithKeyValues:response];
            totalCount = homeStore.totalCount;
            
            for (Findgoodslist  * goodlist in homeStore.storeInfoList.findGoodsList) {
      
                [self.storeListArr addObject:goodlist];
            }
            [self.home_tableView reloadData];
            
            if (self.storeListArr.count == 0 || self.storeListArr == nil) {
                
                [self.home_tableView cyl_reloadData];
            }

        }

        NSLog(@"门店列表 = %@",   self.storeListArr);
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
 
}



#pragma mark - CYLTableViewPlaceHolderDelegate Method
- (UIView *)makePlaceHolderView {
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    UIView *taobaoStyle = [self taoBaoStylePlaceHolder];

    return weChatStyle;
}

//暂无网络
- (UIView *)taoBaoStylePlaceHolder {
    __block XTNetReloader *netReloader = [[XTNetReloader alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                  reloadBlock:^{
                                                                      [self headerRefresh];
                                                                  }] ;
    return netReloader;
}

//暂无数据
- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.home_tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method
- (void)emptyOverlayClicked:(id)sender {
 
    [self PostRequst];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
