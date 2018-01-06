//
//  StoreSearchViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreSearchViewController.h"

#import "DuplicationStoreCell.h"
#import "AllGoodsSelectTypeCollectionCell.h"
#import "StoreDetailHomeModel.h"
#import "GoodsDeltailViewController.h"//商品详情
#import "CQPlaceholderView.h"

#define rowHeight 292

typedef NS_ENUM(NSUInteger, SelectTypeSortBy) {
    SelectTypeSortByComprehensive = 0,//综合排序
    SelectTypeSortBySaleNum,
    SelectTypeSortByLatest,
    SelectTypeSortByPrice,
};

@interface StoreSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectTypeCollectionCellDelegate,UITextFieldDelegate>
{
    NSInteger _flag;//排序类型 flag
    NSString * _searchResult;//搜索结果
}
@property (nonatomic ,strong) NSMutableArray * collctionArray;
@property (nonatomic ,assign) SelectTypeSortBy selectType;
@property (nonatomic , strong) CQPlaceholderView *placeholderView;
@property (nonatomic , strong) UIView *titleView;
@property (nonatomic , strong) UIButton *right_btn;
@property (nonatomic , strong) UITextField * searchtext;
@end

@implementation StoreSearchViewController
 -(NSMutableArray *)collctionArray
{
    if (!_collctionArray) {
        _collctionArray = [NSMutableArray array];
    }
    return _collctionArray;
}
-(UIButton *)set_rightButton
{
    _right_btn          = [UIButton buttonWithType:UIButtonTypeCustom];
    _right_btn.frame = CGRectMake(0, 10, 50, 24);
    _right_btn.titleLabel.font = SYSTEMFONT(14);
    [_right_btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_right_btn setTitle:@"搜索" forState:UIControlStateNormal];
    [_right_btn addTarget:self action:@selector(didSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    return  _right_btn;
}
#pragma mark - 搜索
-(void)didSearchAction:(UIButton*)sender
{
    [_searchtext resignFirstResponder];
    if (_searchResult.length > 0 && ![_searchResult isEqualToString:@""]) {
        
        [self goodsListPostRequestAtOrderSort:@"" AndKeyWord:_searchResult];
    }else{
        [self.view makeToast:@"搜索内容不能为空" duration:2 position:@"center"];
    }
}
#pragma mark - 搜索结果
-(void)textFieldChangeValue:(UITextField*)textField
{
    _searchResult = textField.text;
}
-(UIView *)titleView
{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW -120, 36)];
    _titleView.backgroundColor = RGB(238, 238, 238);
    _titleView.layer.cornerRadius = 6;
    _titleView.layer.masksToBounds = YES;
    
    UIImageView * imageView =[ UIImageView new];
    imageView.image = [UIImage imageNamed:@"search2"];
    imageView.frame = CGRectMake(10, 9, 18, 18);
    [_titleView addSubview:imageView];
    
    _searchtext = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, _titleView.size.width -50 -50, 36)];
    _searchtext.font = SYSTEMFONT(14);
    _searchtext.backgroundColor = RGB(238, 238, 238);
    _searchtext.placeholder = @"搜索店铺内商品";
    _searchtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchtext.delegate = self;
    [_searchtext addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [_titleView addSubview:_searchtext];
    return _titleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCollectView];
    self.navigationItem.titleView = self.titleView;
    //默认为综合
    _selectType = SelectTypeSortByComprehensive;
    [self goodsListPostRequestAtOrderSort:@"" AndKeyWord:@""];
    
}
-(void)footerRefresh
{
    [super footerRefresh];
    switch (_selectType) {
        case SelectTypeSortByComprehensive://综合
            [self goodsListPostRequestAtOrderSort:@"" AndKeyWord:@""];
            
            break;
        case SelectTypeSortBySaleNum://销量
            [self goodsListPostRequestAtOrderSort:@"1" AndKeyWord:@""];
            
            break;
        case SelectTypeSortByLatest://最新
            [self goodsListPostRequestAtOrderSort:@"3" AndKeyWord:@""];
            
            break;
        case SelectTypeSortByPrice://价格
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6" AndKeyWord:@""];
                
            }else{
                [self goodsListPostRequestAtOrderSort:@"5" AndKeyWord:@""];
                
            }
            
            break;
    }
    
}
-(void)headerRefresh
{
    [super headerRefresh];
    switch (_selectType) {
        case SelectTypeSortByComprehensive://综合
            [self goodsListPostRequestAtOrderSort:@"" AndKeyWord:@""];
            
            break;
        case SelectTypeSortBySaleNum://销量
            [self goodsListPostRequestAtOrderSort:@"1" AndKeyWord:@""];
            
            break;
        case SelectTypeSortByLatest://最新;
            [self goodsListPostRequestAtOrderSort:@"3" AndKeyWord:@""];
            
            break;
        case SelectTypeSortByPrice://价格
            
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6" AndKeyWord:@""];
                
            }else{
                [self goodsListPostRequestAtOrderSort:@"5" AndKeyWord:@""];
            }
            break;
    }
}

-(void)initCollectView{
    
    self.view.backgroundColor =   HEXCOLOR(0xf7f7f7);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;   //列距
    layout.minimumLineSpacing = 10;    //行距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW,  KScreenH -64 ) collectionViewLayout:layout];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DuplicationStoreCell" bundle:nil] forCellWithReuseIdentifier:@"DuplicationStoreCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AllGoodsSelectTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"AllGoodsSelectTypeCollectionCell"];
    
    [self.view addSubview:self.collectionView];
    self.zfb_collectionView = self.collectionView;
    [self setupCollectionViewRefresh];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.collctionArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake( KScreenW, 40);
        
    }else{
        return CGSizeMake( KScreenW *0.5- 15, rowHeight);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        AllGoodsSelectTypeCollectionCell * typeCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AllGoodsSelectTypeCollectionCell" forIndexPath:indexPath];
        typeCell.delegate = self;
        return typeCell;
    }else{
        
        DuplicationStoreCell * itemCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DuplicationStoreCell" forIndexPath:indexPath];
        if (self.collctionArray.count >0 ) {
            GoodsExtendList * storelist  = self.collctionArray[indexPath.item];
            itemCell.goodslist = storelist;
        }
        
        return itemCell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDeltailViewController * goodVC = [ GoodsDeltailViewController new];
    if ( self.collctionArray.count > 0) {
        GoodsExtendList * storelist  = self.collctionArray[indexPath.item];
        goodVC.goodsId = [NSString stringWithFormat:@"%ld", storelist.goodsId];
        goodVC.headerImage = storelist.coverImgUrl;
    }
    [self.navigationController pushViewController:goodVC animated: NO];
    
}
#pragma mark - SelectTypeCollectionCellDelegate 排序的代理
-(void)selectStoreType:(StoreScreenType)type flag :(NSInteger)flag
{
    self.currentPage = 1;
    [self.collctionArray removeAllObjects ];
    _flag = flag;
    switch (type) {
        case SelectTypeSortByComprehensive://综合
            
            _selectType = SelectTypeSortByComprehensive;
            [self goodsListPostRequestAtOrderSort:@""AndKeyWord:@""];
            
            NSLog(@"综合排序");
            
            break;
        case SelectTypeSortBySaleNum://销量
            
            _selectType = SelectTypeSortBySaleNum;
            [self goodsListPostRequestAtOrderSort:@"1"AndKeyWord:@""];
            [self headerRefresh];
            
            NSLog(@"销量排序--降序");
            
            break;
        case SelectTypeSortByLatest://最新
            
            _selectType = SelectTypeSortByLatest;
            [self goodsListPostRequestAtOrderSort:@"3" AndKeyWord:@""];
            
            NSLog(@"最新排序--降序");
            
            break;
        case SelectTypeSortByPrice://价格 // 5价格降   6价格升
            NSLog(@"价格排序");
            
            _selectType = SelectTypeSortByPrice;
            if (_flag == 1) {//升序
                [self goodsListPostRequestAtOrderSort:@"6"AndKeyWord:@""];
                
            }else{
                [self goodsListPostRequestAtOrderSort:@"5" AndKeyWord:@""];
            
            }
            break;
    }
}

#pragma mark - 全部商品列表
-(void)goodsListPostRequestAtOrderSort:(NSString *)orderSort AndKeyWord:(NSString*)keyWords
{
    
    NSDictionary * parma = @{
                             @"storeId":_storeId,
                             @"searchText":keyWords,
                             @"orderSort":orderSort,//1销量降 2销量升  3 最新降  4最新升   5价格降   6价格升（查询新品推荐的时候这个要传空字符串 ） 空综合
                             @"page":[NSNumber numberWithInteger:self.currentPage],
                             @"size":[NSNumber numberWithInteger:kPageCount],
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsExtendListApp",zfb_baseUrl] params:parma success:^(id response) {
        StoreDetailHomeModel * store = [StoreDetailHomeModel mj_objectWithKeyValues:response];
        if ([store.resultCode isEqualToString:@"0"]) {
            
            if (self.refreshType == RefreshTypeHeader) {
                if (self.collctionArray.count > 0) {
                    [self.collctionArray removeAllObjects];
                }
            }
            for (GoodsExtendList * storelist in store.data.goodsExtendList) {
                [self.collctionArray addObject:storelist];
            }
            [_placeholderView removeFromSuperview];
            if ([self isEmptyArray:self.collctionArray]) {
                _placeholderView = [[CQPlaceholderView alloc]initWithFrame:self.collectionView.bounds type:CQPlaceholderViewTypeNoGoods delegate:self];
                [self.collectionView addSubview:_placeholderView];
            }
            [self.collectionView reloadData];
        }
        [self endCollectionViewRefresh];
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [self endCollectionViewRefresh];
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchtext resignFirstResponder];
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
