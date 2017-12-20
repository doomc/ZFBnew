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
#import "SearchStoreCell.h"// 搜索门店的cell
//view
#import "SearchTypeView.h"//搜索商品筛选
#import "SearchStoreTypeView.h"//搜索门店
#import "BandSelecteView.h" //选择品牌
#import "SearchTitleView.h"
#import "SearchTabView.h"//显示背景和列表
#import "CQPlaceholderView.h"
#import "XHStarRateView.h"

//model
#import "SearchResultModel.h"//搜索商品model
#import "SearchNoResultModel.h"//搜索无数据的模型
#import "BrandListModel.h"//品牌模型
#import "HomeStoreListModel.h"//门店类型
//vc
#import "GoodsDeltailViewController.h"
#import "MainStoreViewController.h"

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
    NSInteger  _isFeatured;//是否精选内容 1 是 0 不是
    NSInteger  _selectIndex;//筛选条件的下标
    NSString * _bandId;//品牌id
    NSString * _bandName;//品牌名
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
@property (nonatomic , strong) CQPlaceholderView *placeholderView; //占位图

//data
@property (nonatomic , strong) NSMutableArray * hasDataArray;//搜索有结果的数组
@property (nonatomic , strong) NSMutableArray * noResultArray;//搜索无结果的数组

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
-(NSMutableArray *)noResultArray
{
    if (!_noResultArray) {
        _noResultArray = [NSMutableArray array];
    }
    return _noResultArray;
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
    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"SearchStoreCell" bundle:nil] forCellWithReuseIdentifier:@"SearchStoreCell"];
    
    [self.searchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

}
//刷新
-(void)headerRefresh
{
    [super headerRefresh];
    if (_searchType == 0) {//如果搜索商品
        switch (_goodType) { //搜索商品
            case GoodsSearchTypeBand://点击品牌
                
                [self searchGoodsPOSTRequestAndsearchText:@"" brandId:_bandId orderByPrice:@"" orderBySales:@"" labelId:_labelId isFeatured:@""];

                break;
            case GoodsSearchTypePrice://点击价格
                if (_selectIndex == 0) { //高->低 0
                    [self searchGoodsPOSTRequestAndsearchText:_searchText brandId:@"" orderByPrice:@"0" orderBySales:@"" labelId:@"" isFeatured:@""];
                }else{
                    
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"1" orderBySales:@"" labelId:@"" isFeatured:@""];
                }
                break;
            case GoodsSearchTypeSales://点击销售
                if (_selectIndex == 0) { //高->低 0
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"0" labelId:@"" isFeatured:@""];
                }else{
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"1" labelId:@"" isFeatured:@""];
                }
                break;
        }
    }else{
        switch (_storeType) {
            case StoreSearchTypeBand://品牌筛选
                
                [self searchStorePOSTRequestAndbusinessType:_bandName nearBydisc:@"" sercahText:@""];
                break;
                
            case StoreSearchTypeDistence://距离排序
                if (_selectIndex == 0) {
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"3000" sercahText:@""];
                }else if (_selectIndex == 1){
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"5000" sercahText:@""];
                }else{
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"10000" sercahText:@""];
                }
                break;
        }
    }
}
-(void)footerRefresh{
    
    [super footerRefresh];
    if (_searchType == 0) {//如果搜索商品
        switch (_goodType) { //搜索门店
            case GoodsSearchTypeBand://点击品牌
                
                [self searchGoodsPOSTRequestAndsearchText:@"" brandId:_bandId orderByPrice:@"" orderBySales:@"" labelId:_labelId isFeatured:@""];

                break;
            case GoodsSearchTypePrice://点击价格
                if (_selectIndex == 0) { //高->低 0
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"0" orderBySales:@"" labelId:@"" isFeatured:@""];
                }else{
                    
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"1" orderBySales:@"" labelId:@"" isFeatured:@""];
                }
                break;
            case GoodsSearchTypeSales://点击销售
                if (_selectIndex == 0) { //高->低 0
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"0" labelId:@"" isFeatured:@""];
                }else{
                    [self searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"1" labelId:@"" isFeatured:@""];
                }
                break;
        }
    }else{
        switch (_storeType) {
            case StoreSearchTypeBand://品牌筛选
                
                [self searchStorePOSTRequestAndbusinessType:_bandName nearBydisc:@"" sercahText:@""];

                break;
                
            case StoreSearchTypeDistence://距离排序
                if (_selectIndex == 0) {
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"3000" sercahText:@""];
                }else if (_selectIndex == 1){
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"5000" sercahText:@""];
                }else{
                    [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"10000" sercahText:@""];
                }
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _priceArray = @[@"价格由高到低",@"价格由低到高"];
    _distenceArray = @[@"3千米内",@"5千米内",@"10千米内"];
    _salesArray = @[@"销量由高到低",@"销量由低到高"];
    
    [self creatTitleView];
    [self creatSearchCollectionView];
    [self setupCollectionViewRefresh];
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
    [self.view addSubview:_bandCollectionView];
    
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
    __weak typeof(self)weakSelf = self;
    self.coverView = [[SearchTabView alloc]initWithFrame:CGRectMake(0, 50, KScreenW, KScreenH - 50)AndDataCount:array.count];
    self.coverView.dataArray = array;
    self.coverView.indexBlock = ^(NSInteger index) { //距离除外   高->低 0   低到高 1
        NSLog(@"我选择了升序还是降序  -----  %ld",index);
        _selectIndex = index;
        if (weakSelf.searchType == 0) {
            switch (weakSelf.goodType) {
                case GoodsSearchTypeBand://点击品牌
                    
                    break;
                case GoodsSearchTypePrice://点击价格
                    if (_selectIndex == 0) { //高->低 0
                        [weakSelf searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"0" orderBySales:@"" labelId:@"" isFeatured:@""];
                    }else{
                     
                        [weakSelf searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"1" orderBySales:@"" labelId:@"" isFeatured:@""];
                    }
                    break;
                case GoodsSearchTypeSales://点击销售
                    if (_selectIndex == 0) { //高->低 0
                        [weakSelf searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"0" labelId:@"" isFeatured:@""];
                    }else{
                        [weakSelf searchGoodsPOSTRequestAndsearchText:@"" brandId:@"" orderByPrice:@"" orderBySales:@"1" labelId:@"" isFeatured:@""];
                    }
                    break;
            }
        }else{
            switch (weakSelf.storeType) {
                case StoreSearchTypeBand://品牌筛选
 
                    break;
                    
                case StoreSearchTypeDistence://距离排序
                    if (_selectIndex == 0) {
                        [weakSelf searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"3000" sercahText:@""];
                    }else if (_selectIndex == 1){
                        [weakSelf searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"5000" sercahText:@""];
                    }else{
                        [weakSelf searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"10000" sercahText:@""];
                    }
                    break;
            }
        }
      
    };
    [self.view addSubview:_coverView];
    [self.view sendSubviewToBack:self.searchCollectionView];
    [self.view bringSubviewToFront:_coverView];//在集合图层上
}

#pragma mark - SearchTitleViewDelegate titleView  点击输入和搜索代理
//搜索
-(void)didSearch:(UIButton *)sender
{
    self.currentPage = 1;
    if (_searchType == 0) {//如果搜索类型是商品
        [self searchGoodsPOSTRequestAndsearchText:_searchText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:@"" isFeatured:@""];
    }else{//如果搜索类型是门店
        [self searchStorePOSTRequestAndbusinessType:_searchText nearBydisc:@"" sercahText:@""];
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
    self.currentPage = 1;
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
    self.currentPage = 1;
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
    _bandId = brandId;
    _bandName = brandName;
    self.currentPage = 1;
    [self.bandCollectionView removeFromSuperview];//先移除

    if (_searchType == 0) {//搜索商品
        [self searchGoodsPOSTRequestAndsearchText:@"" brandId:brandId orderByPrice:@"" orderBySales:@"" labelId:_labelId isFeatured:@""];
    }else{//搜索门店
        
        [self searchStorePOSTRequestAndbusinessType:brandName nearBydisc:@"" sercahText:@""];
    }
    [self.searchCollectionView reloadData];

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
    if (_isFeatured == 0) {
        return self.hasDataArray.count;
    }else{
        return self.noResultArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchType == 0) {//为商品搜索时
        if (_isFeatured == 0) {
            SearchHasDataCell * hasDataCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHasDataCell" forIndexPath:indexPath];
            if (self.hasDataArray.count > 0) {
                ResultFindgoodslist * goodlist =  self.hasDataArray[indexPath.item];
                hasDataCell.goodList = goodlist;
            }
            return hasDataCell;

        }else{
            DuplicationStoreCell * isFeaturedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
        
            if (self.noResultArray.count > 0) {
                SearchFindgoodslist * goodlist =  self.noResultArray[indexPath.item];
                isFeaturedCell.goodsList = goodlist;
            }
            return isFeaturedCell;
        }
        
    }else{//为门店搜索时
        SearchStoreCell * storeCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchStoreCell" forIndexPath:indexPath];
        Findgoodslist  * storelist = self.hasDataArray[indexPath.item];
        storeCell.storelist = storelist;
        //初始化五星好评控件
        XHStarRateView * wdStarView = [[XHStarRateView alloc]initWithFrame:storeCell.starView.frame numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:NO littleStar:@"0"];//da星星
        wdStarView.currentScore = storelist.starLevel;
        [storeCell addSubview:wdStarView];
        
        return storeCell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchType == 0) {
        if (_isFeatured == 0) {
            return CGSizeMake(KScreenW, 132);
        }else{
            return CGSizeMake( (KScreenW - 30)*0.5 , 292);
        }
    }else{
        return CGSizeMake(KScreenW, 92);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_searchType == 0) {
        if (_isFeatured == 0) {
            return UIEdgeInsetsZero;
        }else{
            return UIEdgeInsetsMake(10, 10, 10, 10);
        }
    }else{
        return UIEdgeInsetsZero;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
     if (_searchType == 0) {
         if (_isFeatured == 0) {
             return CGSizeZero;
         }else{ //精选的头部
             return CGSizeMake(KScreenW, 250);
         }
     } else{
         return CGSizeZero;
     }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * headView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (_isFeatured == 0) {
            if (self.hasDataArray.count > 0) {
 
                headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
                return headView;
                
            }else{
                headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
                headView.backgroundColor = HEXCOLOR(0xf7f7f7);
                UIImageView * placeholderView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_data2"]];
                placeholderView.contentMode = UIViewContentModeScaleAspectFit;
                [headView addSubview:placeholderView];
                
                [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(headView);
                    make.size.mas_equalTo(CGSizeMake(120, 120));
                }];
                UILabel * title     = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.height - 50, KScreenW, 50)];
                title.textColor     = HEXCOLOR(0x333333);
                title.backgroundColor = [UIColor whiteColor];
                title.textAlignment = NSTextAlignmentCenter;
                title.text          = @"为你精选";
                title.font          = [UIFont systemFontOfSize:14];
                [headView addSubview:title];
                
                return headView;
            }
        }else{ //精选
            headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            headView.backgroundColor = HEXCOLOR(0xf7f7f7);
            UIImageView * placeholderView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_data2"]];
            placeholderView.contentMode = UIViewContentModeScaleAspectFit;
            [headView addSubview:placeholderView];
            
            [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(headView);
                make.size.mas_equalTo(CGSizeMake(120, 120));
            }];
            
            UILabel * title     = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.height - 50, KScreenW, 50)];
            title.textColor     = HEXCOLOR(0x333333);
            title.textAlignment = NSTextAlignmentCenter;
            title.text          = @"为你精选";
            title.backgroundColor = [UIColor whiteColor];
            title.font          = [UIFont systemFontOfSize:14];
            [headView addSubview:title];
            return headView;
        }
 
    }
    return headView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDeltailViewController *  goodsVC = [GoodsDeltailViewController new];
    if (_searchType == 0) {
        if (_isFeatured == 0) {
            ResultFindgoodslist * goodlist  = self.hasDataArray[indexPath.row];
            goodsVC.shareId = @"";
            goodsVC.shareNum = @"";
            goodsVC.headerImage = goodlist.coverImgUrl;
            goodsVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
            [self.navigationController pushViewController:goodsVC animated:NO];
        }else{
            SearchFindgoodslist * goodlist = self.noResultArray[indexPath.row];
            goodsVC.shareId = @"";
            goodsVC.shareNum = @"";
            goodsVC.headerImage = goodlist.coverImgUrl;
            goodsVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodsId];
            [self.navigationController pushViewController:goodsVC animated:NO];
        }


    }else{
        MainStoreViewController * storeVC = [ MainStoreViewController new];
        SearchFindgoodslist * storeList  = self.hasDataArray[indexPath.row];
        storeVC.storeId = [NSString stringWithFormat:@"%ld", storeList.storeId];
        [self.navigationController pushViewController:storeVC animated:NO];
    }
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
{
    NSDictionary * param = @{
                             
                             @"sercahText":searchText,
                             @"brandId":brandId,
                             @"orderByPrice":orderByPrice,
                             @"orderBySales":orderBySales,
                             @"labelId":labelId,
                             @"isFeatured":isFeatured,
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"goodsType":@""
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
            if (result.data.findGoodsList.count > 0) { //搜索有结果 隐藏heander图
                _isFeatured = 0;//不用精选
                [self.noResultArray removeAllObjects];
                [self setupCollectionViewRefresh];

            }else{ //需要精选推荐
                _isFeatured = 1;
                [self.hasDataArray removeAllObjects];
                [self isFeaturePost];
                [self removeRefresh];
                
            }
            [self.searchCollectionView reloadData];
            [SVProgressHUD dismiss];
        }
        [self endCollectionViewRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endCollectionViewRefresh];
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
            [self.searchCollectionView reloadData];
            [SVProgressHUD dismiss];
        }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self removeRefresh];
        [SVProgressHUD dismiss];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
        
    }];
    
}
#pragma mark  - getCmStoreInfo用于查找门店
/**
 搜索门店接口
 
 @param businessType 经营种类   品牌Name
 @ payType 是否支持到店付款    1支持  0不支持
 @ latitude 纬度
 @ longitude 经度
 @ param orderBydisc 距离排序   1升   0降
 @ orderbylikeNum 人气排序   1升   0降
 @ nearBydisc 获取附近门店    1  获取10公里以内的门店
 @param sercahText 搜索关键字
 */
-(void)searchStorePOSTRequestAndbusinessType:(NSString *)businessType
                                  nearBydisc:(NSString *)nearBydisc
                                  sercahText:(NSString *)sercahText
{
    NSDictionary * param = @{
                             @"businessType":businessType,
                             @"serviceType" : @"",
                             @"latitude":BBUserDefault.latitude,
                             @"longitude":BBUserDefault.longitude,
                             @"orderBydisc":@"",
                             @"nearBydisc":nearBydisc,
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"sercahText":sercahText,
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCmStoreInfo",zfb_baseUrl] params:param success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            if (self.refreshType  == RefreshTypeHeader) {
                if (self.hasDataArray.count > 0) {
                    [self.hasDataArray removeAllObjects];
                }
            }
            HomeStoreListModel  * homeStore = [HomeStoreListModel mj_objectWithKeyValues:response];
            for (Findgoodslist * storelist in homeStore.storeInfoList.findGoodsList) {
                [self.hasDataArray addObject:storelist];
            }
            NSLog(@"门店列表         = %@",   self.hasDataArray);
            _isFeatured = 0;//不用精选
            [self setupCollectionViewRefresh];
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.hasDataArray]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.searchCollectionView.bounds type:CQPlaceholderViewTypeNoSearchData delegate:self];
                [self.searchCollectionView addSubview:_placeholderView];
            }
            [SVProgressHUD dismiss];
            [self.searchCollectionView reloadData];
        }
         [self endCollectionViewRefresh];
       
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [self endCollectionViewRefresh];
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
        [self searchGoodsPOSTRequestAndsearchText:_searchText brandId:@"" orderByPrice:@"" orderBySales:@"" labelId:_labelId isFeatured:@""];

    }else{ //如果搜索门店
        [self creatStoreView];
        [self.searchGoodsView removeFromSuperview];
        [self searchStorePOSTRequestAndbusinessType:@"" nearBydisc:@"" sercahText:_searchText];
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
