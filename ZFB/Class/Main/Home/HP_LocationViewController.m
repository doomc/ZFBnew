//
//  HP_LocationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  首页定位


#import "HP_LocationViewController.h"
//cell
#import "SearchCell.h"
#import "HPLocationCell.h"
//view
#import "MapPoiTableView.h"
//高德api
#import <AMapLocationKit/AMapLocationKit.h>
#import "CLLocation+MPLocation.h"

@interface HP_LocationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
{
    NSIndexPath *  _selectedIndexPath;
    NSInteger      _pageIndex;
    BOOL _isFirst;
}

//poi
@property (nonatomic,strong) AMapSearchAPI *  search;
@property (nonatomic,retain) NSMutableArray * dataList;
@property (strong,nonatomic) NSMutableArray * searchList;
@property (nonatomic,assign) BOOL isSelected;//是否点击了搜索，点击之前都是只能匹配

//end
@property (nonatomic,strong) UITableView * location_TableView;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) UIView * bgView;

//高德api


@end

@implementation HP_LocationViewController

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenW , 50)];
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [self imageWithColor:HEXCOLOR(0xf2f2f2) size:_searchBar.bounds.size];
        _searchBar.placeholder = @"搜索商品或门店";
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTableViewInterface];

}
-(void)creatTableViewInterface
{
    self.title = @"选择地址";
    _isFirst  = YES;//默认第一次进来
    //创建bgView
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenW,50 )];
    [self.view addSubview:_bgView];
    [_bgView addSubview:self.searchBar];
    
    
    //tableView的创建
    self.location_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, KScreenW, KScreenH - 114) style:UITableViewStyleGrouped];
    [self.view addSubview:self.location_TableView];
    
    self.location_TableView.dataSource = self;
    self.location_TableView.delegate = self;
    
    [self.location_TableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCellid"];
    [self.location_TableView registerNib:[UINib nibWithNibName:@"HPLocationCell" bundle:nil] forCellReuseIdentifier:@"HPLocationCellid"];

    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //设置搜索内容
    self.searchBar.text = _searchStr;
    NSLog(@"搜索界面%@,%@",_currentLocation,_currentCity);

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}


#pragma mark -  UITableViewDelegate    UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!_isSelected) {
            return [self.searchList count];
        }else{
            return [self.dataList count];
        }
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.001;
    if (section == 1) {
        height = 40;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0.00;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (section==1) {
        
        UIView * bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
        bgview.backgroundColor =HEXCOLOR(0xffcccc);
        
        UILabel * _lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
        _lb.textColor = HEXCOLOR(0x363636);
        _lb.text = @"附近地址";
        _lb.font = [UIFont systemFontOfSize:15.0];
        [bgview addSubview:_lb];
        
        return bgview;
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        SearchCell * searchCell = [self.location_TableView
                                   dequeueReusableCellWithIdentifier:@"SearchCellid" forIndexPath:indexPath];
        return searchCell;
    }
   else {
        HPLocationCell * cell = [self.location_TableView
                                 dequeueReusableCellWithIdentifier:@"HPLocationCellid" forIndexPath:indexPath];
        //如果搜索框激活
        if (!_isSelected) {
            AMapPOI *poi = _searchList[indexPath.row];
            [cell.lb_title setText:poi.name];
            [cell.lb_detail setText:poi.address];
        }
        else{
            AMapPOI *poi = _dataList[indexPath.row];
            [cell.lb_title setText:poi.name];
            [cell.lb_detail setText:poi.address];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self searchPoiText:_searchStr];
    }else{
        [self.searchBar resignFirstResponder];
        AMapPOI *poi = [[AMapPOI alloc]init];
        //如果搜索框激活
        if (!_isSelected) {
            poi = _searchList[indexPath.row];
            
        }
        else{
            poi = _dataList[indexPath.row];
        }
        NSLog(@"%@,%f,%f",poi.name,poi.location.latitude,poi.location.longitude);
        self.moveBlock(poi);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//以下的两个方法必须设置.searchBar.delegate 才可以
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
    if (_isFirst == YES) {
        [self searchPoiText:_searchStr];
    }
    _isFirst = NO;

    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
    return YES;
}
//当搜索框中的内容发生改变时会自动进行搜索,这个是经常用的
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"正在编辑--- %@",searchText);
    [self searchPoiText:searchText];
}

//在键盘中的搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了搜索");
    [self searchPoiText:searchBar.text];
}
#pragma mark - 公共方法
-(void)searchPoiText:(NSString * )searchText
{
    //发起输入提示搜索
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = searchText;
    tipsRequest.city = _currentCity;
    [_search AMapInputTipsSearch: tipsRequest];
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    
    [self.dataList removeAllObjects];
    for (AMapPOI *poi in response.pois) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@\nPOI: %@,%@", poi.description,poi.name,poi.address]);
        //搜索结果存在数组
        [self.dataList addObject:poi];
    }
    _isSelected = YES;
    [self.location_TableView reloadData];
    
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    //先清空数组
    [self.searchList removeAllObjects];
    for (AMapTip *p in response.tips) {

        //把搜索结果存在数组
        [self.searchList addObject:p];
    }
    _isSelected = NO;
    //刷新表格
    [self.location_TableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
