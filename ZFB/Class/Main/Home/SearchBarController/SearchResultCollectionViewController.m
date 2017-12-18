//
//  SearchResultCollectionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchResultCollectionViewController.h"
//cell
#import "DuplicationStoreCell.h"//无数据的cell
#import "SearchHasDataCell.h"//有数据的cell

//view
#import "SearchTypeView.h"//搜索商品筛选
#import "SearchStoreTypeView.h"//搜索门店
#import "BandSelecteView.h" //选择品牌
#import "SearchTitleView.h"
#import "SearchTabView.h"//显示背景和列表
//model
#import "SearchResultModel.h"//搜索商品model
#import "SearchNoResultModel.h"//搜索无数据的模型
#import "BrandListModel.h"//品牌模型
//vc
#import "GoodsDeltailViewController.h"

@interface SearchResultCollectionViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    SearchTypeViewDelegate,
    SearchStoreTypeViewDelegate,
    BandSelecteViewDelegate,
    SearchTitleViewDelegate
>
{
    NSInteger _isFeatured;//是否精选内容 1 是 0 不是
}

//UI
@property (nonatomic , strong) UIButton * searchButton;//搜索
@property (nonatomic , strong) UICollectionView * searchCollectionView;
@property (nonatomic , strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic , strong) SearchTypeView * searchGoodsView;//搜索商品
@property (nonatomic , strong) SearchStoreTypeView * searchStoreView;//搜索门店
@property (nonatomic , strong) BandSelecteView * bandCollectionView;//筛选品牌
@property (nonatomic , strong) SearchTitleView * titleView;
@property (nonatomic , strong) SearchTabView * coverView;//筛选列表

//data
@property (nonatomic , strong) NSMutableArray * hasDataArray;//搜索有结果的数组
@property (nonatomic , strong) NSMutableArray * hasNoDataArray;//搜索无数据的数组
@property (nonatomic , assign) GoodsSearchType  goodType ;//搜索商品枚举
@property (nonatomic , assign) StoreSearchType  storeType;//搜索店铺枚举
@property (nonatomic , strong) NSArray * priceArray;//价格
@property (nonatomic , strong) NSArray * distenceArray;//距离
@property (nonatomic , strong) NSArray * salesArray;//销量
@property (nonatomic , strong) NSMutableArray * bandArray;//品牌


@end

@implementation SearchResultCollectionViewController
-(NSMutableArray *)hasDataArray
{
    if (!_hasDataArray) {
        _hasDataArray = [NSMutableArray array];
    }
    return _hasDataArray;
}
-(NSMutableArray *)hasNoDataArray
{
    if (!_hasNoDataArray) {
        _hasNoDataArray = [NSMutableArray array];
    }
    return _hasNoDataArray;
}
-(NSMutableArray *)bandArray
{
    if (!_bandArray) {
        _bandArray = [NSMutableArray array];
    }
    return _bandArray;
}

-(void)creatSearchCollectionView
{
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _searchCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, KScreenW, KScreenH-50-64) collectionViewLayout:_flowLayout];
    _searchCollectionView.delegate = self;
    _searchCollectionView.dataSource = self;
    _searchCollectionView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview: self.searchCollectionView];
    self.zfb_collectionView = self.searchCollectionView;
    
    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"SearchHasDataCell" bundle:nil] forCellWithReuseIdentifier:@"SearchHasDataCell"];
    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    [self.searchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _priceArray = @[@"价格由高到低",@"价格由低到高"];
    _distenceArray = @[@"距离由远到近",@"距离由近到远"];
    _salesArray = @[@"销量由高到低",@"销量由低到高"];
    
    [self creatTitleView];
    [self creatSearchCollectionView];
}
-(UIButton *)set_rightButton
{
    //搜索
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    _searchButton.frame = CGRectMake(5, 7, 40, 30);
    _searchButton.titleLabel.font = SYSTEMFONT(14);
    [_searchButton addTarget:self action:@selector(didSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView: _searchButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    return _searchButton;
}
//导航输入
-(void)creatTitleView
{
    //创建titleView
    _titleView = [[SearchTitleView alloc]initWithTitleViewFrame:CGRectMake(0, 0, KScreenW - 100, 36) andLeadingWidth:15];
    _titleView.delegate = self;
    [_titleView.selectTypeBtn removeFromSuperview];
    self.navigationItem.titleView = _titleView;
}
//搜索门店的筛选
-(void)creatStoreView
{
    _searchStoreView = [[SearchStoreTypeView alloc]initWithSearchStoreViewFrame:CGRectMake(0, 0, KScreenW, 50)];
    _searchStoreView.delegate = self;
    [UIView animateWithDuration:2 animations:^{
        _searchStoreView.alpha = 1;
        [self.view addSubview:_searchStoreView];
    } completion:^(BOOL finish){
    }];
    
}
//品牌的筛选
-(void)creatBandViewAndBandArray:(NSMutableArray *)bandArray
{
    _bandCollectionView = [[BandSelecteView alloc]initWithBandSelecteViewFrame:CGRectMake(0, 50, KScreenW, 210+50)];
    _bandCollectionView.delegate = self;
    _bandCollectionView.brandListArray = bandArray;
    [UIView animateWithDuration:2 animations:^{
        [self.view addSubview:_bandCollectionView];
    } completion:^(BOOL finish){
    }];
}
//搜索商品的筛选
-(void)creatgoodsView
{
    _searchGoodsView = [[SearchTypeView alloc]initWithSearchTypeViewFrame:CGRectMake(0, 0, KScreenW, 50)];
    _searchGoodsView.delegate = self;
    [self.view sendSubviewToBack:self.searchCollectionView];
    [self.view bringSubviewToFront:_searchGoodsView];//在集合图层上
    [UIView animateWithDuration:2 animations:^{
        [self.view addSubview:_searchGoodsView];
    } completion:^(BOOL finish){
    }];
    
}
//筛选列表 - 数组代表传入的
-(void)creatsListViewWithArray:(NSArray *)array
{
    _coverView = [[SearchTabView alloc]initWithFrame:CGRectMake(0, 50, KScreenW, KScreenH - 50)];
    _coverView.indexBlock = ^(NSInteger index) {
        NSLog(@"我选择了升序还是降序  -----  %ld",index);
    };
    _coverView.dataArray = array;
    [self.view addSubview:_coverView];
    [self.view sendSubviewToBack:self.searchCollectionView];
    [self.view bringSubviewToFront:_coverView];//在集合图层上
}

#pragma mark - SearchTitleViewDelegate titleView  点击输入和搜索代理
//搜索
-(void)didSearch:(UIButton *)sender
{
    if (_searchType == 0) {//如果搜索类型是商品
        
    }else{//如果搜索类型是门店
        
    }
}
//文字编辑
-(void)didChangeText:(NSString *)text
{
    _searchText = text;
}
#pragma mark - searchGoodsViewDelegate 搜索商品的代理
-(void)selectGoodsSearchType:(GoodsSearchType)searchType
{
    _goodType = searchType;
    [_bandCollectionView removeFromSuperview];
    [_coverView removeFromSuperview];
    switch (_goodType) {
        case GoodsSearchTypeBand://点击品牌
            [self creatBandViewAndBandArray:_bandArray];
            break;
        case GoodsSearchTypePrice://点击价格
            [self creatsListViewWithArray:_priceArray];

            break;
        case GoodsSearchTypeSales://点击销售
            [self creatsListViewWithArray:_salesArray];

            break;
    }
}
#pragma mark - SearchStoreTypeViewDelegate 搜索门店的代理
-(void)selectStoreSearchType:(StoreSearchType)searchType
{
    _storeType = searchType;
    [_bandCollectionView removeFromSuperview];
    [_coverView removeFromSuperview];
    switch (_storeType) {
        case StoreSearchTypeBand://品牌筛选
            [self creatBandViewAndBandArray:_bandArray];

            break;
        case StoreSearchTypeDistence://距离排序
            
            [self creatsListViewWithArray:_distenceArray];

            break;
    }
}
#pragma mark - BandSelecteViewDelegate 选择品牌代理
-(void)didSelectedIndex:(NSInteger )index brandId :(NSString *)brandId brandName :(NSString *)brandName
{
    NSLog(@"我选中了 %@",brandName);
    [self.bandCollectionView removeFromSuperview];

}
//取消操作
-(void)didClickCancel
{
    //移除
    [self.bandCollectionView removeFromSuperview];
}
//确定操作  后检索
-(void)didClickConfirm
{
    //移除
    [self.bandCollectionView removeFromSuperview];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hasDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchHasDataCell * hasDataCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHasDataCell" forIndexPath:indexPath];
    
//    DuplicationStoreCell * isFeaturedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"isFeaturedCell" forIndexPath:indexPath];
    
    if (self.hasDataArray.count > 0) {
        ResultFindgoodslist * goodlist =  self.hasDataArray[indexPath.item];
        hasDataCell.goodList = goodlist;
    }
    return hasDataCell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KScreenW, 132);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.hasDataArray.count > 0) {
        return CGSizeZero;

    }else{
        return CGSizeMake(KScreenW, 200);

    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * headView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (self.hasDataArray.count > 0) {
            headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            return headView;
         }else{
            
            headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            UIImageView * placeholderView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"placeholder"]];
            placeholderView.contentMode = UIViewContentModeScaleAspectFit;
            [headView addSubview:placeholderView];
            
            [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headView);
                make.size.mas_equalTo(CGSizeMake(100, 100));
            }];
            
            UILabel * lb_center = [[UILabel alloc]initWithFrame:CGRectMake((KScreenW-100)/2, 150, 100, 30)];
            lb_center.text      = @"搜索无结果~";
            lb_center.font      = [UIFont systemFontOfSize:14];
            lb_center.textColor = HEXCOLOR(0x7a7a7a);
            return headView;
        }
    }
    return headView;
}

#pragma mark - 获取品牌列表接口findBrandList
-(void)getFindbrandListPost
{
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/findBrandList",zfb_baseUrl] params:nil success:^(id response) {
        BrandListModel  * brand = [BrandListModel mj_objectWithKeyValues:response];
        if (self.bandArray.count > 0) {
            [self.bandArray removeAllObjects];
        }
        for (BrandFindbrandlist * brandlist  in brand.data.findBrandList) {
            [self.bandArray addObject:brandlist];
        }
        [self.bandCollectionView reload_CollctionView];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
}
//
//#pragma mark  - isFeaturePost搜索 精品
//-(void)isFeaturePost
//{
//    NSDictionary * param = @{
//                             
//                             @"sercahText":@"",
//                             @"brandId":@"",
//                             @"orderByPrice":@"",
//                             @"orderBySales":@"",
//                             @"labelId":@"",
//                             @"isFeatured":@"1",
//                             @"size":[NSNumber numberWithInteger:kPageCount],
//                             @"page":[NSNumber numberWithInteger:self.currentPage],
//                             };
//    
//    [SVProgressHUD show];
//    
//    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getProSearch",zfb_baseUrl] params:param success:^(id response) {
//        
//        if ([response[@"resultCode"]  isEqualToString: @"0"]) {
//            if (self.refreshType  == RefreshTypeHeader) {
//                if ( self.noResultArray.count > 0) {
//                    [self.noResultArray removeAllObjects];
//                }
//            }
//            SearchNoResultModel  * nodata = [SearchNoResultModel mj_objectWithKeyValues:response];
//            NSInteger totalcount = nodata.data.totalCount ;
//            NSLog(@"totala = = = %ld",totalcount);
//            for (SearchFindgoodslist * goodlist in nodata.data.findGoodsList) {
//                [self.noResultArray addObject:goodlist];
//            }
//            [self.tableView reloadData];
//            [SVProgressHUD dismiss];
//            [self endRefresh];
//            
//        }
//    } progress:^(NSProgress *progeress) {
//        
//        NSLog(@"progeress=====%@",progeress);
//        
//    } failure:^(NSError *error) {
//        [self endRefresh];
//        
//        [SVProgressHUD dismiss];
//        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
//        NSLog(@"error=====%@",error);
//        
//    }];
//    
//}

#pragma mark  - getProSearch用于查找商品-商品标签

/**
 搜搜商品接口
 
 @param searchText 搜索关键词
 @param brandId //品牌id
 @param orderByPrice //商品价格排序    价格排序  1升 0降
 @param orderBySales //商品售量排序    销量排序  1升0降
 @param labelId  //标签id
 @param isFeatured //是否精选    是否精选  1是 0 否
 
 */
-(void)searchGoodsPOSTRequestAndsearchText:(NSString *)searchText
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
                if (self.hasDataArray.count > 0) {
                    [self.hasDataArray removeAllObjects];
                }
            }
            SearchResultModel * result = [SearchResultModel mj_objectWithKeyValues:response];
            for (ResultFindgoodslist * goodlist in result.data.findGoodsList) {
                [self.hasDataArray addObject:goodlist];
            }
            [SVProgressHUD dismiss];
        }
        [self.searchCollectionView reloadData];
        [self endRefresh];
        
        if (self.hasDataArray.count > 0) { //搜索有结果 隐藏heander图
            _isFeatured = 0;//不用精选
//            [self.view bringSubviewToFront:_resultView];//如果搜索有结果，_resultView在置顶
            
        }else{ //需要精选推荐
            _isFeatured = 1;
//            [self.view sendSubviewToBack:_resultView]; //如果无数据 在滞后 在精选列表
//            [self isFeaturePost];
            
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}
#pragma mark  - getCmStoreInfo用于查找门店
/**
 搜索门店接口
 
 @param businessType 经营种类       如:服装，小吃等等
 @ payType 是否支持到店付款    1支持  0不支持
 @ latitude 纬度
 @ longitude 经度
 @param orderBydisc 距离排序   1升   0降
 @param orderbylikeNum 人气排序   1升   0降
 @ nearBydisc 获取附近门店    1  获取10公里以内的门店
 @param sercahText 搜索关键字
 */
-(void)searchStorePOSTRequestAndbusinessType:(NSString *)businessType
                                 orderBydisc:(NSString *)orderBydisc
                              orderbylikeNum:(NSString *)orderbylikeNum
                                  sercahText:(NSString *)sercahText

{
    NSDictionary * param = @{
                             @"businessType":businessType,
                             @"payType":@"",
                             @"latitude":@"",
                             @"longitude":@"",
                             @"orderBydisc":orderBydisc,
                             @"orderbylikeNum":orderbylikeNum,
                             @"nearBydisc":@"",
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"sercahText":sercahText,
                             @"serviceType" : @""//商品1级类别id
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:param success:^(id response) {
        if (self.refreshType  == RefreshTypeHeader) {
            
        }
        [SVProgressHUD dismiss];
        [self endRefresh];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getFindbrandListPost];
    
    if (_searchType == 0) {//如果搜索商品
        [self creatgoodsView];
        [self.searchStoreView removeFromSuperview];
        //商品搜索
        [self searchGoodsPOSTRequestAndsearchText:_searchText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:_labelId isFeatured:@"" goodsType:_goodsType];

    }else{ //如果搜索门店
        [self creatStoreView];
        [self.searchGoodsView removeFromSuperview];

        [self searchStorePOSTRequestAndbusinessType:@"" orderBydisc:@"" orderbylikeNum:@"" sercahText:_searchText];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titleView.tf_search resignFirstResponder];
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
