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
//model
#import "SearchResultModel.h"//搜索商品model
#import "SearchNoResultModel.h"//搜索无数据的模型
#import "BrandListModel.h"//品牌模型
//vc
#import "GoodsDeltailViewController.h"

@interface SearchResultCollectionViewController ()
<
//    UICollectionViewDelegate,
//    UICollectionViewDataSource,
//    UICollectionViewDelegateFlowLayout,
    SearchTypeViewDelegate,SearchStoreTypeViewDelegate,BandSelecteViewDelegate,SearchTitleViewDelegate
>
{
    NSString *_searchText ;//搜索内容
}

//UI
@property (nonatomic , strong) UIButton * searchButton;//搜索
//@property (nonatomic , strong) UICollectionView * searchCollectionView;
//@property (nonatomic , strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic , strong) SearchTypeView * searchGoodsView;//搜索商品
@property (nonatomic , strong) SearchStoreTypeView * searchStoreView;//搜索门店
@property (nonatomic , strong) BandSelecteView * bandCollectionView;//筛选品牌
@property (nonatomic , strong) SearchTitleView * titleView;

//data
@property (nonatomic , strong) NSMutableArray * hasDataArray;//搜索有结果的数组
@property (nonatomic , strong) NSMutableArray * hasNoDataArray;//搜索无数据的数组
@property (nonatomic , assign) GoodsSearchType  goodType ;//搜索商品枚举
@property (nonatomic , assign) StoreSearchType  storeType;//搜索店铺枚举


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
//-(UICollectionView *)searchCollectionView
//{
//    if (!_searchCollectionView) {
//        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//
//        _searchCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, KScreenW, KScreenH-50-64) collectionViewLayout:_flowLayout];
//        _searchCollectionView.delegate = self;
//        _searchCollectionView.dataSource = self;
//    }
//    return _searchCollectionView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview: self.searchCollectionView];
//    self.zfb_collectionView = self.searchCollectionView;
//
//    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"SearchHasDataCell" bundle:nil] forCellWithReuseIdentifier:@"SearchHasDataCell"];
//    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    
    [self creatTitleView];
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
    _titleView = [[SearchTitleView alloc]initWithTitleViewFrame:CGRectMake(0, 0, KScreenW - 100, 36)];
    _titleView.delegate = self;
    _titleView.leadingWidth = 0;
    [_titleView.selectTypeBtn removeFromSuperview];
    self.navigationItem.titleView = _titleView;
}
//搜索门店的筛选
-(void)creatStoreView
{
    _searchStoreView = [[SearchStoreTypeView alloc]initWithSearchStoreViewFrame:CGRectMake(0, 0, KScreenW, 50)];
    _searchStoreView.delegate = self;
    [self.view addSubview:_searchStoreView];
}
//品牌的筛选
-(void)creatBandView
{
    _bandCollectionView = [[BandSelecteView alloc]initWithBandSelecteViewFrame:CGRectMake(0, 50, KScreenW, 210)];
    _bandCollectionView.delegate = self;
    [self.view addSubview:_bandCollectionView];
}
//搜索商品的筛选
-(void)creatgoodsView
{
    _searchGoodsView = [[SearchTypeView alloc]initWithSearchTypeViewFrame:CGRectMake(0, 0, KScreenW, 50)];
    _searchGoodsView.delegate = self;
    [self.view addSubview:_searchGoodsView];
    //    [self.view bringSubviewToFront:self.searchCollectionView];//在集合图层上
    
}

#pragma mark - SearchTitleViewDelegate titleView  点击输入和搜索代理
//搜索
-(void)didSearch:(UIButton *)sender
{
    
}

//文字编辑
-(void)didChangeText:(NSString *)text
{
    
}
#pragma mark - searchGoodsViewDelegate 搜索商品的代理
-(void)selectGoodsSearchType:(GoodsSearchType)searchType
{
    _goodType = searchType;
    switch (_goodType) {
        case GoodsSearchTypeBand://点击品牌
            
            break;
        case GoodsSearchTypePrice://点击价格
            
            break;
        case GoodsSearchTypeSales://点击销售
            
            break;
    }
}
#pragma mark - SearchStoreTypeViewDelegate 搜索门店的代理
-(void)selectStoreSearchType:(StoreSearchType)searchType
{
    _storeType = searchType;
    switch (_storeType) {
        case StoreSearchTypeBand://品牌筛选
            
            break;
        case StoreSearchTypeDistence://距离排序
            
            break;
    }
}
#pragma mark - BandSelecteViewDelegate 选择品牌代理
-(void)didSelectedIndex:(NSInteger )index brandId :(NSString *)brandId brandName :(NSString *)brandName
{
    
}
//取消操作
-(void)didClickCancel
{
    
}

//确定操作  后检索
-(void)didClickConfirm
{
    
}

#pragma mark - UICollectionViewDataSource
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 2;
//}
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SearchHasDataCell * hasDataCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchHasDataCell" forIndexPath:indexPath];
//    return hasDataCell;
//}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (_searchType == 0) {//如果搜索商品
        [self creatgoodsView];
        [self.searchStoreView removeFromSuperview];
    }else{ //如果搜索门店
        [self creatStoreView];
        [self.searchGoodsView removeFromSuperview];
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
