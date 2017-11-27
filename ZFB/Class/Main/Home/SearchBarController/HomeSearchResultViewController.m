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
#import "BrandListModel.h"//品牌模型
//vc
//#import "DetailFindGoodsViewController.h"
#import "GoodsDeltailViewController.h"

@interface HomeSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SearchTypeCollectionViewDelegate,SearchTypeViewDelegate >

{
    NSString * _brandId ;//获取品牌
    NSUInteger _priceSort ;//价格排序  价格排序  1升 0降
    NSUInteger _salesSort ;//销售排序     排序  1升 0降
 
}

//返回结果无数据的view
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *noResultArray;//精选数据，搜索无结果数据
@property (nonatomic ,strong) UIView  * headView;//无数据显示的view
@property (nonatomic, assign) NSInteger    isFeatured;//是否精选  1是 0 否

//返回有结果的view
@property (nonatomic, strong) UITableView *resultTableView;//返回结果的tableview
@property (nonatomic, strong) UIView *  resultView;//返回结有数据的view
@property (nonatomic, strong) NSMutableArray *searchListArray;//search到的array
@property (nonatomic ,strong) SearchTypeView           * searchTypeHeaderView;//选择检索类型
@property (nonatomic ,strong) SearchTypeCollectionView * searchCollectionView;//品牌列表
@property (nonatomic ,strong) UIView                   * popBgView;//品牌弹框

//公共
@property (nonatomic ,strong) UIView                   * titleView;//导航视图

@property (nonatomic, strong) NSArray *distenceList;
@property (nonatomic, strong) NSArray *salesList;
@property (nonatomic, strong) NSArray *priceList;

//品牌列表 数据源
@property (nonatomic, strong) NSMutableArray * brandListArray;


@end



@implementation HomeSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _priceList    = @[@"0-290",@"300-500",@"1000+",@"50000+"];
    _distenceList = @[@"附近", @"1km", @"3km", @"5km",@"10km",@"全城"];
    _salesList    = @[@"智能排序", @"离我最近", @"好评优先", @"人气最高"];
    
//    self.searchBar.text = _resultsText;//设置一个搜索默认值
    
    //创建titleView
    [self creatTitleView];
    

    _resultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
   
    [self.view addSubview:_resultView];

    //有数据的tableView
    [self.resultView addSubview:self.resultTableView];
    
    //无数据tableview
    [self.view addSubview: self.tableView];
 
    [self addtableViewHeadview];//添加headview （无数据状态下）
    
    [self addSelectedTpye];//选择分类类型（noResultArray = 0 的状态下显示）
    
    [self setupRefresh];
    
 

}
#pragma mark -数据请求
-(void)headerRefresh {
    [super headerRefresh];
 
     if ([self.searchType isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:_resultsText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
        
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""  sercahText:_searchBar.text];
    }

}
-(void)footerRefresh {
    
    [super footerRefresh];
    
    if ([self.searchType  isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:_resultsText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
        
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""  sercahText:_searchBar.text];
    }
}

//////////////////////////////////无结果需要加载的视图///////////////////////////////////////
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

//////////////////////////////////有结果需要加载的视图///////////////////////////////////////
//创建titleView
-(void)creatTitleView
{
    //创建titleView
    _titleView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView addSubview:self.searchBar];
    self.zfb_tableView = self.tableView ;
    
}
//创建选择类型视图
-(void)addSelectedTpye
{
 
    _searchTypeHeaderView          = [[NSBundle mainBundle]loadNibNamed:@"SearchTypeView" owner:self options:nil].lastObject;
    _searchTypeHeaderView.frame    = CGRectMake(0, 0, KScreenW, 40);
    _searchTypeHeaderView.delegate = self;
    [self.resultView addSubview: _searchTypeHeaderView];
    
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
    
     NSInteger count = self.brandListArray.count ;
    // ceil(count/2.0) 最大取整
    //140  = 30*2+40*2
    _searchCollectionView                              = [[SearchTypeCollectionView alloc]initWithFrame:CGRectMake(0,40, KScreenW, 30 * ceil(count/2.0) + 2*40+10) collectionViewLayout:layout];
    
    _searchCollectionView.brandListArray = self.brandListArray;
    _searchCollectionView.typeDelegate = self;

    _searchCollectionView.showsVerticalScrollIndicator = NO;
    [_popBgView addSubview:_searchCollectionView];
    
}

#pragma mark --懒加载
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar                 = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 50, 44)];
        _searchBar.delegate        = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder     = @"搜索";
    }
    return _searchBar;
}
#pragma mark - tableView  有数据的列表
-(UITableView *)resultTableView
{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0,  44  , KScreenW, KScreenH-44-64 ) style:UITableViewStylePlain];
        _resultTableView.estimatedRowHeight = 0;

        //加载xib
        [_resultTableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil] forCellReuseIdentifier:@"resultCellid"];
        _resultTableView.delegate   = self;
        _resultTableView.dataSource = self;
    }
    return _resultTableView;
}
#pragma mark - tableView  无数据的列表
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 0  , KScreenW, KScreenH ) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0;

        //加载xib
        [self.tableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil] forCellReuseIdentifier:@"resultCellid"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSMutableArray *)noResultArray
{
    if (!_noResultArray) {
        _noResultArray = [NSMutableArray array];
    }
    return _noResultArray;
}
-(NSMutableArray *)brandListArray
{
    if (!_brandListArray) {
        _brandListArray =[ NSMutableArray array];
    }
    return _brandListArray;
}
-(NSMutableArray *)searchListArray
{
    if (!_searchListArray ) {
        _searchListArray  = [NSMutableArray array];
    }
    return _searchListArray;
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
    button.selected = !button.selected;
    
    button.selected  =  _priceSort > 0 ?  1 : 0;
 
    [self SearchgoodsPOSTRequestAndsearchText:_searchBar.text brandId:_brandId orderByPrice:[NSString stringWithFormat:@"%ld",_priceSort] orderBySales:[NSString stringWithFormat:@"%ld",_salesSort] labelId:_labelId isFeatured:@"" goodsType:_goodsType];
    
}
///销量排序
-(void)salesSortAction:(UIButton *)button
{
    
    button.selected = !button.selected;
    
    button.selected  = _salesSort > 0 ?  1 : 0;
    
    [self SearchgoodsPOSTRequestAndsearchText:_searchBar.text brandId:_brandId orderByPrice:[NSString stringWithFormat:@"%ld",_priceSort] orderBySales:[NSString stringWithFormat:@"%ld",_salesSort] labelId:_labelId isFeatured:@"" goodsType:_goodsType ];

}
///距离排序
-(void)distenceSortAction:(UIButton *)button
{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.tableView == tableView) {
        return 2;

    }
    else{
        return 1;
    }
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.tableView == tableView) {
       
        if (section == 1 ) {
       
            return  self.noResultArray.count;
        }
        return 0;

    }
    return self.searchListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return  130 /375.0* KScreenW;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        if (section == 1) {
            return 40;
        }
        return 0.001;

    }
    return 0.001;
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = nil;
    UIFont *font     = [UIFont systemFontOfSize:14];
    
    if (self.tableView == tableView) {
      
        if (section== 1) {
            
            headView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreenW, 35)];
            [headView setBackgroundColor:HEXCOLOR(0xffcccc)];
            
            UILabel * title     = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 5.0f, 200.0f, 30.0f)];
            title.textColor     = HEXCOLOR(0x363636);
            title.textAlignment = NSTextAlignmentLeft;
            title.text          = @"为你精选";
            title.font          = font;
            [headView addSubview:title];
            
            UIImageView * logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond"] ];//logo
            logo.frame = CGRectMake(5, 5, 30, 30);
            [headView addSubview:logo];

            return headView;
        }
  
    }
    
    return headView;
}
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.tableView == tableView) {
        GuessCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"resultCellid" forIndexPath:indexPath];
        [cell.zan_Image removeFromSuperview];
        [cell.loca_img removeFromSuperview];
        [cell.lb_collectNum removeFromSuperview];
        [cell.lb_distence removeFromSuperview];
        if (self.noResultArray.count > 0) {
            SearchFindgoodslist  * nogoods = self.noResultArray[indexPath.row];
            cell.sgoodlist           = nogoods;
        }
        return cell;

    }else{
        
        GuessCell * resultCell = [self.resultTableView dequeueReusableCellWithIdentifier:@"resultCellid" forIndexPath:indexPath];
        [resultCell.zan_Image removeFromSuperview];
        [resultCell.loca_img removeFromSuperview];
        [resultCell.lb_collectNum removeFromSuperview];
        [resultCell.lb_distence removeFromSuperview];
        if (self.searchListArray.count > 0) {
            ResultFindgoodslist  * result = self.searchListArray[indexPath.row];
            resultCell.resultgGoodslist = result;
        }
        
        return resultCell;

    }
 
    return nil;
}
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    NSLog(@" sction1 == %ld  ---  row1 == %ld",indexPath.section ,indexPath.row);

    
    GoodsDeltailViewController * detailVC = [GoodsDeltailViewController new];

    if (_isFeatured == 1) {
        if (self.noResultArray.count > 0 ) {
            SearchFindgoodslist * goodlist = self.noResultArray[indexPath.row];//精选数据跳转
            detailVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
        }
        [self.navigationController pushViewController:detailVC animated:NO];
        
    }else{
        if (self.searchListArray.count > 0) {
            ResultFindgoodslist * findGoods = self.searchListArray[indexPath.row];//搜索到的商品数据跳转
            detailVC.goodsId = [NSString stringWithFormat:@"%ld",findGoods.goodsId];

        }
        [self.navigationController pushViewController:detailVC animated:NO];

  
    }
 
}
////////////////////////////////////////////////////////////////////////////////

#pragma mark -  UISearchBarDelegate 搜索代理
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"------开始编辑---%@",searchBar.text);
 
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"------结束编辑");
    return YES;
}
#pragma mark - 点击搜索后的方法
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText ==== %@",searchText);
    if ([self.searchType isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:searchText brandId:@""orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
   
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@"" sercahText:searchBar.text];
    }
    _resultsText = searchText;
    
}

//点击键盘搜索后的方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索方法");
    [searchBar resignFirstResponder];
    if ([self.searchType  isEqualToString:@"商品"]) {
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:searchBar.text brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
        
    }else{
        
        [self searchStorePOSTRequestAndbusinessType:@"" payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@"" sercahText:searchBar.text];
    }
}


#pragma mark - SearchTypeCollectionViewDelegate 选择品牌
-(void)didSelectedIndex:(NSInteger )index brandId :(NSString *)brandId brandName:(NSString *)brandName
{
    [self.view endEditing:YES];

    NSLog(@"品牌index === %ld   brandId == %@  brandName = %@",index,brandId,brandName);

    [_popBgView removeFromSuperview];
    [_searchCollectionView  removeFromSuperview];
    [self.searchBar resignFirstResponder];
    
    //不管精选不精选 都搜索
    [self SearchgoodsPOSTRequestAndsearchText:@"" brandId:brandId orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
   
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
 @param sercahText 搜索关键字
 */
-(void)searchStorePOSTRequestAndbusinessType:(NSString *)businessType
                                     payType:(NSString *)payType
                                    latitude:(NSString *)latitude
                                   longitude:(NSString *)longitude
                                 orderBydisc:(NSString *)orderBydisc
                              orderbylikeNum:(NSString *)orderbylikeNum
                                  nearBydisc:(NSString *)nearBydisc
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
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"sercahText":sercahText,
                             @"serviceType" : @""//商品1级类别id
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:param success:^(id response) {
        if (self.refreshType  == RefreshTypeHeader) {
 
        }
        [SVProgressHUD dismissWithDelay:1];
        [self endRefresh];

    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [self endRefresh];
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

 */
-(void)SearchgoodsPOSTRequestAndsearchText:(NSString *)searchText
                                   brandId:(NSString *)brandId
                              orderByPrice:(NSString *)orderByPrice
                              orderBySales:(NSString *)orderBySales
                                   labelId:(NSString *)labelId
                                isFeatured:(NSString *)isFeatured
                                goodsType:(NSString *)goodsType


{
    if (goodsType == nil) {
        goodsType = @"";
    }
    NSDictionary * param = @{
                             
                             @"sercahText":searchText,
                             @"brandId":brandId,
                             @"orderByPrice":orderByPrice,
                             @"orderBySales":orderBySales,
                             @"labelId":labelId,
                             @"isFeatured":isFeatured,
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"goodsType":goodsType
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getProSearch",zfb_baseUrl] params:param success:^(id response) {
        
        if ([response[@"resultCode"]  isEqualToString: @"0"]) {
            if (self.refreshType  == RefreshTypeHeader) {
                
                if (self.searchListArray.count > 0) {
                    
                    [self.searchListArray removeAllObjects];
                }
  
            }
            SearchResultModel * result = [SearchResultModel mj_objectWithKeyValues:response];
            
            for (ResultFindgoodslist * goodlist in result.data.findGoodsList) {
                
                [self.searchListArray addObject:goodlist];
            }
            
            [SVProgressHUD dismiss];
        }
        [self.resultTableView reloadData];
        [self endRefresh];

        if (self.searchListArray.count > 0) {
            _isFeatured = 0;//不用精选
            [self.view bringSubviewToFront:_resultView];//如果搜索有结果，_resultView在置顶

        }else{
            _isFeatured = 1;
            [self.view sendSubviewToBack:_resultView]; //如果无数据 在滞后 在精选列表
            [self isFeaturePost];
 
        }
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}
#pragma mark  - isFeaturePost搜索 精品
-(void)isFeaturePost
{
    NSDictionary * param = @{
                             
                             @"sercahText":@"",
                             @"brandId":@"",
                             @"orderByPrice":@"",
                             @"orderBySales":@"",
                             @"labelId":@"",
                             @"isFeatured":@"1",
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getProSearch",zfb_baseUrl] params:param success:^(id response) {
    
        if ([response[@"resultCode"]  isEqualToString: @"0"]) {
            if (self.refreshType  == RefreshTypeHeader) {
                
                if ( self.noResultArray.count > 0) {
                    
                    [self.noResultArray removeAllObjects];
                    
                }
                
            }
            SearchNoResultModel  * nodata = [SearchNoResultModel mj_objectWithKeyValues:response];
            
            NSInteger totalcount = nodata.data.totalCount ;
            
            NSLog(@"totala = = = %ld",totalcount);
            
            for (SearchFindgoodslist * goodlist in nodata.data.findGoodsList) {
                
                [self.noResultArray addObject:goodlist];
                
            }
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            [self endRefresh];
            
        }
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [self endRefresh];

        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];

}
#pragma mark - 获取品牌列表接口findBrandList
-(void)getFindbrandListPost
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/findBrandList",zfb_baseUrl] params:nil success:^(id response) {
    
        BrandListModel  * brand = [BrandListModel mj_objectWithKeyValues:response];
        
        if (self.brandListArray.count > 0) {
            
            [self.brandListArray removeAllObjects];
        }
        for (BrandFindbrandlist * brandlist  in brand.data.findBrandList) {
            
            [self.brandListArray addObject:brandlist];
            
        }
        [self.searchCollectionView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_popBgView removeFromSuperview];
    [_searchCollectionView  removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
 
    [self getFindbrandListPost];
    
    if ([self.searchType  isEqualToString:@"商品"]) {
      
        //商品搜索
        [self SearchgoodsPOSTRequestAndsearchText:_resultsText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@"" goodsType:_goodsType];
        
    }else{
        //门店搜索
        [self searchStorePOSTRequestAndbusinessType:_resultsText payType:@"1" latitude:@"" longitude:@"" orderBydisc:@"" orderbylikeNum:@"" nearBydisc:@""  sercahText:_searchBar.text];
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
