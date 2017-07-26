//
//  HomeSearchResultViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomeSearchResultViewController.h"
//view
#import "SearchTypeView.h"
#import "SearchTypeCollectionView.h"

//cell
#import "GuessCell.h"

//model
#import "SearchResultModel.h"//搜索商品model
#import "SearchNoResultModel.h"//搜索无数据的模型


@interface HomeSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate,SearchTypeViewDelegate >


@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchList;//search到的array
@property (nonatomic, strong) NSMutableArray *noResultArray;//精选数据，搜索无结果数据

@property (nonatomic ,strong) UIButton                 * selectbutton;//搜索选择方式
@property (nonatomic ,strong) SearchTypeView           * searchTypeHeaderView;//选择方式
@property (nonatomic ,strong) UIView                   * titleView;
@property (nonatomic ,strong) UIView                   * popBgView;//全屏背景
@property (nonatomic ,strong) SearchTypeCollectionView * searchCollectionView;//品牌列表

@property (nonatomic, strong) NSArray *distenceList;
@property (nonatomic, strong) NSArray *salesList;
@property (nonatomic, strong) NSArray *priceList;
@property (nonatomic, assign) BOOL    isFeatured;//是否精选  1是 0 否
@property (nonatomic ,strong) UIView  * headView;//无数据显示的view


@end


@implementation HomeSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _priceList    = @[@"0-290",@"300-500",@"1000+",@"50000+"];
    _distenceList = @[@"附近", @"1km", @"3km", @"5km",@"10km",@"全城"];
    _salesList    = @[@"智能排序", @"离我最近", @"好评优先", @"人气最高"];
    
    _isFeatured = NO;//默认有精选 无数据
    
    
    
    self.searchBar.text = _resultsText;
    
    //创建titleView
    [self creatTitleView];
    
    //添加视图
    [self.view addSubview: self.tableView];
    
    
    if (self.noResultArray.count > 0) {
        //添加headview （无数据状态下）
        [self addtableViewHeadview];
    }
    else{//添加选择搜索类型（noResultArray = 0 的状态下显示）
        
        [self addSelectedTpye];
    }
    
    
}
//添加headview
-(void)addtableViewHeadview
{
    self.headView               = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 200)];
    UIImageView * placeholderView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder"]];
    placeholderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headView addSubview:placeholderView];
    
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headView);
    }];
    
    UILabel * lb_center = [[UILabel alloc]initWithFrame:CGRectMake((KScreenW-100)/2, 150, 100, 30)];
    lb_center.text      = @"搜索无结果~";
    lb_center.font      = [UIFont systemFontOfSize:14];
    lb_center.textColor = HEXCOLOR(0x7a7a7a);
    [self.headView addSubview:lb_center];
    
    self.tableView.tableHeaderView        = self.headView;
    self.tableView.tableHeaderView.height = 200;
    
}
//创建titleView
-(void)creatTitleView
{
    //创建titleView
    _titleView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView addSubview:self.selectbutton];
    [_titleView addSubview:self.searchBar];
    
}
//创建选择类型视图
-(void)addSelectedTpye
{
    _searchTypeHeaderView          = [[NSBundle mainBundle]loadNibNamed:@"SearchTypeView" owner:self options:nil].lastObject;
    _searchTypeHeaderView.frame    = CGRectMake(0, 64, KScreenW, 40);
    _searchTypeHeaderView.delegate = self;
    [self.view addSubview: _searchTypeHeaderView];
    
    
}
//选择品牌列表
-(void)popCollectionView
{
    _popBgView                 = [[UIView alloc]initWithFrame: CGRectMake(0, 0, KScreenW, KScreenH)];
    _popBgView.backgroundColor = RGBA(0, 0, 0, 0.15);
    [self.view addSubview:_popBgView];
    [self.tableView bringSubviewToFront:_popBgView];
    
    //创建集合视图
    UICollectionViewFlowLayout *layout                 = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection                             = UICollectionViewScrollDirectionVertical;
    layout.itemSize                                    = CGSizeMake( (KScreenW - 120) / 2,  30);
    _searchCollectionView                              = [[SearchTypeCollectionView alloc]initWithFrame:CGRectMake(0,64+40, KScreenW, 230) collectionViewLayout:layout];
    _searchCollectionView.showsVerticalScrollIndicator = NO;
    [_popBgView addSubview:_searchCollectionView];
    
}

#pragma mark --懒加载
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar                 = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 2*50, 44)];
        _searchBar.delegate        = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder     = @"搜索";
    }
    return _searchBar;
}

#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 64+44  , KScreenW, KScreenH-64-44 ) style:UITableViewStylePlain];
        //加载xib
        [self.tableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil] forCellReuseIdentifier:@"resultCellid"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIButton *)selectbutton
{
    if (!_selectbutton) {
        _selectbutton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbutton.backgroundColor = HEXCOLOR(0xfe6d6a);
        //默认值
        [_selectbutton setTitle:@"商品" forState:UIControlStateNormal];
        _selectbutton.frame              = CGRectMake(5, 7, 40, 30);
        _selectbutton.titleLabel.font    = [UIFont systemFontOfSize:14];
        _selectbutton.layer.cornerRadius = 4;
        _selectbutton.clipsToBounds      = YES;
        [_selectbutton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectbutton;
}
-(NSMutableArray *)noResultArray
{
    if (!_noResultArray) {
        _noResultArray = [NSMutableArray array];
    }
    return _noResultArray;
}
#pragma mark -  选择搜索类型
-(void)selectTypeAction :(UIButton *)sender
{
    [sender setTag:1001];
    
    [YBPopupMenu showRelyOnView:sender titles:TITLES  icons:nil menuWidth:60 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth       = 0.5;
        popupMenu.arrowHeight       = 5;
        popupMenu.arrowWidth        = 10;
        popupMenu.fontSize          = 14;
        popupMenu.delegate          = self;
        popupMenu.borderColor       = HEXCOLOR(0xfe6d6a);
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@" %@ 1001",TITLES[index]);
    
    [self.selectbutton setTitle:TITLES[index] forState:UIControlStateNormal];
    
}


#pragma mark - SearchTypeViewDelegate
///品牌选择
-(void)brandActionlist:(UIButton *)button
{
    NSLog(@"需要 条件");
    
    [self popCollectionView];
    
}
///价格排序
-(void)priceSortAction:(UIButton *)button
{
    
}
///销量排序
-(void)salesSortAction:(UIButton *)button
{
    
    
}
///距离排序
-(void)distenceSortAction:(UIButton *)button
{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1 ) {
        return  self.noResultArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = nil;
    UIFont *font     = [UIFont systemFontOfSize:14];
    
    if (section== 1) {
        headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
        [headView setBackgroundColor:HEXCOLOR(0xffcccc)];
        
        UILabel * title     = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 3.0f, 200.0f, 30.0f)];
        title.textColor     = HEXCOLOR(0x363636);
        title.textAlignment = NSTextAlignmentLeft;
        title.text          = @"为你精选";
        title.font          = font;
        [headView addSubview:title];
        
        UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond"] ];//定位icon
        logo.frame         = CGRectMake(5, 5, 25, 25);
        [headView addSubview:logo];
        return headView;
        
    }
    
    return headView;
}
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GuessCell * resultCell = [self.tableView dequeueReusableCellWithIdentifier:@"resultCellid" forIndexPath:indexPath];
    [resultCell.zan_Image removeFromSuperview];
    [resultCell.loca_img removeFromSuperview];
    [resultCell.lb_collectNum removeFromSuperview];
    [resultCell.lb_distence removeFromSuperview];
    
    SearchFindgoodslist  * nogoods = self.noResultArray[indexPath.row];
    resultCell.sgoodlist           = nogoods;
    
    return resultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" sction == %ld  ---  row == %ld",indexPath.section ,indexPath.row);
}


#pragma mark -  UISearchBarDelegate 选择搜索类型
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"------开始编辑");
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"------结束编辑");
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
}

//点击键盘搜索后的方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索方法");
    [searchBar resignFirstResponder];
    if ([self.selectbutton.titleLabel.text isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:searchBar.text brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"1" page:@"1" size:@"6"];
        
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@"" page:@"1" size:@"6" sercahText:searchBar.text];
    }
}

#pragma mark  ----  searchBar delegate
//   searchBar开始编辑响应
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //因为闲置时赋了空格，防止不必要的bug，在启用的时候先清空内容
    self.searchBar.text = @"";
}


//取消键盘 搜索框闲置的时候赋给其一个空格，保证放大镜居左
- (void)registerFR{
    
    if ([self.searchBar isFirstResponder]) {
        self.searchBar.text = _resultsText;
        [self.searchBar resignFirstResponder];
    }
}



#pragma mark  - getCmStoreInfo用于查找门店
/**
 搜索门店接口
 
 @param businessType 经营种类       如:服装，小吃等等
 @param payType 是否支持到店付款    1支持  0不支持
 @param latitude 纬度
 @param longitude 经度
 @param orderBydisc 距离排序   1升   0降
 @param orderbylikeNum 人气排序   1升   0降
 @param nearBydisc 获取附近门店    1  获取10公里以内的门店
 @param page 页码
 @param size 大小
 @param sercahText 搜索关键字
 */
-(void)searchStorePOSTRequestAndbusinessType:(NSString *)businessType
                                     payType:(NSString *)payType
                                    latitude:(NSString *)latitude
                                   longitude:(NSString *)longitude
                                 orderBydisc:(NSString *)orderBydisc
                              orderbylikeNum:(NSString *)orderbylikeNum
                                  nearBydisc:(NSString *)nearBydisc
                                        page:(NSString *)page
                                        size:(NSString *)size
                                  sercahText:(NSString *)sercahText

{
    NSDictionary * param = @{
                             @"businessType":businessType,
                             @"payType":payType,
                             @"latitude":latitude,
                             @"longitude":longitude,
                             @"orderBydisc":orderBydisc,
                             @"orderbylikeNum":orderbylikeNum,
                             @"nearBydisc":nearBydisc,
                             @"page":page,
                             @"size":size,
                             @"sercahText":sercahText,
                             
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:param success:^(id response) {
        
        [SVProgressHUD dismissWithDelay:1];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
    
}
#pragma mark  - getProSearch用于查找商品-商品标签

/**
 搜搜商品接口
 
 @param searchText 搜索关键词
 @param brandId //品牌id
 @param orderByPrice //商品价格排序	价格排序  1升 0降
 @param orderBySales //商品售量排序	销量排序  1升0降
 @param labelId  //标签id
 @param isFeatured //是否精选	是否精选  1是 0 否
 @param page  // 	页码
 @param size   //默认是十条数据
 */
-(void)SearchgoodsPOSTRequestAndsearchText:(NSString *)searchText
                                   brandId:(NSString *)brandId
                              orderByPrice:(NSString *)orderByPrice
                              orderBySales:(NSString *)orderBySales
                                   labelId:(NSString *)labelId
                                isFeatured:(NSString *)isFeatured
                                      page:(NSString *)page
                                      size:(NSString *)size

{
    NSDictionary * param = @{
                             
                             @"sercahText":searchText,
                             @"brandId":brandId,
                             @"orderByPrice":orderByPrice,
                             @"orderBySales":orderBySales,
                             @"labelId":labelId,
                             @"isFeatured":isFeatured,
                             @"page":page,
                             @"size":size,
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getProSearch",zfb_baseUrl] params:param success:^(id response) {
        
        if ([response[@"resultCode"]  isEqualToString: @"0"]) {
            
            SearchNoResultModel  * nodata = [SearchNoResultModel mj_objectWithKeyValues:response];
            
            NSInteger totalcount = nodata.data.totalCount ;
            
            NSLog(@"totala %ld",totalcount);
            
            for (SearchFindgoodslist * goodlist in nodata.data.findGoodsList) {
                
                [self.noResultArray addObject:goodlist];
                
            }
            [self.tableView reloadData];
            
            [SVProgressHUD dismissWithDelay:1];
            
        }
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_popBgView removeFromSuperview];
    [_searchCollectionView  removeFromSuperview];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.selectbutton.titleLabel.text isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"1" page:@"1" size:@"6"];
        
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@"" page:@"1" size:@"6" sercahText:_searchBar.text];
    }
    
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
