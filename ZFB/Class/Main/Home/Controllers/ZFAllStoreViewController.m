//
//  ZFAllStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部门店

#import "ZFAllStoreViewController.h"
#import "AllStoreCell.h"
#import "SDCycleScrollView.h"

#import "MainStoreViewController.h"
#import "AllStoreModel.h"
#import "HomeADModel.h"
#import "ClassLeftListModel.h"
//map
#import <CoreLocation/CoreLocation.h>

//view
#import "ZspMenu.h"
#import "XHStarRateView.h"
#import "CQPlaceholderView.h"

@interface ZFAllStoreViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CLLocationManagerDelegate,ZspMenuDataSource, ZspMenuDelegate>
{
    NSString * _storeTypeInfo;//门店类型
    BOOL _isChanged;//切换距离最近
    
    NSString *currentCityAndStreet;//当前城市
    NSString *latitudestr;//经度
    NSString *longitudestr;//纬度
    
    NSString * _currentName;
 
    
}
@property (nonatomic,strong) NSMutableArray * allStoreArray;//全部门店数据源
@property (nonatomic,strong) NSMutableArray * listArray;//弹框数据源
@property (nonatomic,strong) NSMutableArray * imgArray;//轮播图
@property (nonatomic,strong) NSMutableArray * titlelistArray;//门店列表选项
@property (nonatomic,strong) CQPlaceholderView * placeholderView;

@property (nonatomic,strong) UITableView * all_tableview;
@property (nonatomic,strong) UITableView * select_tableview;
@property (nonatomic,strong) UIView      * sectionView;
@property (nonatomic,strong) UIButton    * farway_btn;
@property (nonatomic,strong) UIButton    * all_btn;
@property (nonatomic,weak  ) UIButton    * selectedBtn;

//高德api
@property (nonatomic,strong) CLLocationManager * locationManager;

@property (nonatomic, strong) ZspMenu *menu;
@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, strong) NSArray *sortAll;
@property (nonatomic, strong) NSArray *choose;


@end

@implementation ZFAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"全部门店";

    _sort = @[@"距离最近", @"人气最高"];
    _sortAll = @[@"全部门店"];

    _isChanged = YES;//默认切换全部 （No?yes : 距离最近 /全部）
    
    self.zfb_tableView = self.all_tableview;
    
    [self.view addSubview:self.all_tableview];
    
    [self.all_tableview registerNib:[UINib nibWithNibName:@"AllStoreCell" bundle:nil]
             forCellReuseIdentifier:@"AllStoreCell"];
    [self.select_tableview registerNib:[UINib nibWithNibName:@"SelectTableviewCell" bundle:nil]forCellReuseIdentifier:@"SelectTableviewCell"];
    
    [self setupRefresh];

    [self CDsyceleSettingRunningPaintWithArray:self.imgArray];//轮播图
    
    [self ADpagePostRequst];
    
    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"1" orderbylikeNum:@"" nearBydisc:@"" serviceType:@""];//距离最近
    
}
#pragma mark -数据请求
-(void)headerRefresh {
    [super headerRefresh];
    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"1" orderbylikeNum:@"" nearBydisc:@"" serviceType:@""];//距离最近
}
-(void)footerRefresh {
    [super footerRefresh];
    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"1" orderbylikeNum:@"" nearBydisc:@"" serviceType:@""];//距离最近
}

-(UITableView *)all_tableview
{
    if (!_all_tableview) {
        _all_tableview                = [[UITableView alloc]initWithFrame:CGRectMake(0, 175.0/375*KScreenW+44, KScreenW, KScreenH -44-175.0/375*KScreenW-64) style:UITableViewStylePlain];
        _all_tableview.delegate       = self;
        _all_tableview.dataSource     = self;
    }
    return _all_tableview;
}

-(NSMutableArray *)allStoreArray{
    if (!_allStoreArray) {
        _allStoreArray =[NSMutableArray array];
    }
    return _allStoreArray;
}
-(NSMutableArray *)titlelistArray
{
    if (!_titlelistArray) {
        _titlelistArray =[NSMutableArray array];
    }
    return _titlelistArray;
}
-(NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray =[NSMutableArray array];
    }
    return _imgArray;
}

/**初始化轮播 */
-(void)CDsyceleSettingRunningPaintWithArray:(NSArray *)imgArray
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *  _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenW, 175.0/375*KScreenW) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.imageURLStringsGroup = imgArray;
    _cycleScrollView.pageControlAliment   = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate             = self;
    
    //自定义dot 大小和图案pageControlCurrentDot
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_normal"];
    _cycleScrollView.pageDotImage        = [UIImage imageNamed:@"dot_selected"];
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];// 自定义分页控件小圆标颜色
    [self.view addSubview:_cycleScrollView];
    
    _menu            = [[ZspMenu alloc] initWithOrigin:CGPointMake(0, 175) andHeight:44];
    _menu.delegate   = self;
    _menu.dataSource = self;
    [_menu selectDeafultIndexPath];
    [self.view addSubview:_menu];
    
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    //  [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


#pragma mark -  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allStoreArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AllStoreCell *all_cell = [self.all_tableview
                              dequeueReusableCellWithIdentifier:@"AllStoreCell" forIndexPath:indexPath];
    
    Findgoodslists * goodlist = self.allStoreArray[indexPath.row];
    all_cell.storelist        = goodlist;
    XHStarRateView *  wdStarView;
    if (!all_cell.Xh_starView ) {
      wdStarView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 70, 20) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
        wdStarView.currentScore = goodlist.starLevel;
        [all_cell.starView addSubview:wdStarView];
         all_cell.Xh_starView = wdStarView;
    }else{
        
        wdStarView = all_cell.Xh_starView;
        all_cell.Xh_starView.currentScore = goodlist.starLevel;
    }
    return all_cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    NSLog(@" section1==== %ld ,row1 ====  %ld",indexPath.section ,indexPath.row);
    MainStoreViewController *  stroeVC =[[ MainStoreViewController alloc]init];
    Findgoodslists * storelist = self.allStoreArray[indexPath.row];
    stroeVC.storeId = [NSString stringWithFormat:@"%ld",storelist.storeId];
    [self.navigationController pushViewController:stroeVC animated:YES];
    [self.all_tableview reloadData];
}




#pragma mark - 全部门店网络请求
-(void)allStorePostRequstAndbusinessType:(NSString *)businessType
                             orderBydisc:(NSString *)orderBydisc
                         orderbylikeNum :(NSString *)orderbylikeNum
                              nearBydisc:(NSString *)nearBydisc
                              serviceType:(NSString *)serviceType
{
    
    NSDictionary * parma = @{
                             
                             @"longitude":BBUserDefault.longitude,//经度
                             @"latitude":BBUserDefault.latitude ,//纬度
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"businessType":businessType,//经营种类       如:服装，小吃等等
                             @"payType":@"",//是否支持到店付款    1支持  0不支持
                             @"orderBydisc":orderBydisc,//距离排序   1升   0降
                             @"orderbylikeNum":orderbylikeNum,//	人气排序   1升   0降
                             @"nearBydisc":nearBydisc,//获取附近门店    1  获取10公里以内的门店
                             @"sercahText":nearBydisc,//搜索关键词
                             @"serviceType" : serviceType,//商品1级类别id

                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType == RefreshTypeHeader) {
                if (self.allStoreArray.count > 0) {
                    [self.allStoreArray removeAllObjects];
                }
            }
            AllStoreModel  * homeStore = [AllStoreModel mj_objectWithKeyValues:response];
            for (Findgoodslists * goodlist in homeStore.storeInfoList.findGoodsList) {
                [self.allStoreArray addObject:goodlist];
            }
            NSLog(@"门店列表         = %@",   self.allStoreArray);
           
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.allStoreArray]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.all_tableview.bounds type:CQPlaceholderViewTypeNoGoods delegate:self];
                [self.all_tableview addSubview:_placeholderView];
            }
            [self.all_tableview reloadData];
            [SVProgressHUD dismiss];

        }
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [self checkClassPostRequst];
    [self settingNavBarBgName:@"nav64_gray"];

}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
#pragma mark - ZspMenuDataSource, ZspMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    
    return 2;
}

- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {

    if (column == 0) {
        
        return _sort.count;
    }
    else {
        
        return _titlelistArray.count;
    }
}

- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0) {

        return _sort[indexPath.row];
        
    }else{
        if (self.titlelistArray.count > 0) {
            CmgoodsClasstypelist * type  = _titlelistArray[indexPath.row];
            return type.name;
        }
        else{
            return _sortAll[indexPath.row];
        }
    }
}

- (void)menu:(ZspMenu *)menu didSelectRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (self.titlelistArray.count > 0) {
        CmgoodsClasstypelist * type  = _titlelistArray[indexPath.row];
        if (indexPath.item >= 0) {
            NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
        }else {
            NSLog(@"点击了 %ld - %ld",indexPath.column,indexPath.row);
            if (indexPath.column  == 0) {
                _currentName = _sort[indexPath.row];
                
                if (indexPath.row == 0) {
                    //距离最近
                    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"1" orderbylikeNum:@"" nearBydisc:@"" serviceType:@""];
                }else{
                    //人气最高
                    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"0" nearBydisc:@"" serviceType:@""];
                    
                }
                
            }else{
                _currentName = type.name;
                if (indexPath.row == 0) { //全部
                    [self allStorePostRequstAndbusinessType:@"" orderBydisc:@"1" orderbylikeNum:@"" nearBydisc:@"" serviceType:[NSString stringWithFormat:@"%ld",type.typeId]];
                    
                }else{
                    [self allStorePostRequstAndbusinessType:_currentName orderBydisc:@"" orderbylikeNum:@"0" nearBydisc:@"" serviceType:[NSString stringWithFormat:@"%ld",type.typeId]];
                    
                }
            }
        }
    }
    
    [self.all_tableview reloadData];

}

#pragma mark  - 第一级分类网络请求
-(void)checkClassPostRequst{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getMaxType",zfb_baseUrl] params:nil success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            
            if (self.titlelistArray.count > 0) {
                [self.titlelistArray removeAllObjects];
            }
            ClassLeftListModel * list = [ClassLeftListModel mj_objectWithKeyValues:response];
            for (CmgoodsClasstypelist * Typelist in list.data.CmGoodsTypeList) {
                [self.titlelistArray addObject:Typelist];
            }
            [self.all_tableview reloadData];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark - 广告轮播-getAdImageInfo网络请求
-(void)ADpagePostRequst
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getAdImageInfo",zfb_baseUrl] params:nil success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.imgArray.count >0) {
                [self.imgArray  removeAllObjects];
            }else{
                HomeADModel * homeAd = [HomeADModel mj_objectWithKeyValues:response];
                for (Cmadvertimglist * adList in homeAd.data.cmAdvertImgList) {
                    [self.imgArray addObject:adList.imgUrl];
                }
            }
            [self CDsyceleSettingRunningPaintWithArray:self.imgArray];//轮播图
            [self.all_tableview reloadData];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    _currentName = nil;
}


@end
