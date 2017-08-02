//
//  ZFClassifyCollectionViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  功能分类

#import "ZFClassifyCollectionViewController.h"
//Model
#import "CollectionCategoryModel.h"
#import "ClassLeftListModel.h"
//cell  View
#import "ZFCollectionViewCell.h"
#import "LeftTableViewCell.h"
#import "CollectionViewHeaderView.h"
#import "ZFCollectionViewFlowLayout.h"
//controller
#import "DetailFindGoodsViewController.h"
#import "HomeSearchResultViewController.h"


@interface ZFClassifyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource; ///左列表
@property (nonatomic, strong) NSMutableArray *collectionDatas;//数据
@property (nonatomic, strong) ZFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) UIButton *selectbutton;
@property (nonatomic, strong) UIView *titleView;


@end

@implementation ZFClassifyCollectionViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
    NSString * _typeId;

}
#pragma mark - Getters
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)collectionDatas
{
    if (!_collectionDatas)
    {
        _collectionDatas = [NSMutableArray array];
    }
    return _collectionDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建titleView
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView addSubview:self.selectbutton];
    [_titleView addSubview:self.searchBar];
    
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self classListTableVieWithGoodTypePostRequset];//一级
}
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 2*50, 44)];
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder =@"搜索";
    }
    return _searchBar;
}
-(UIButton *)selectbutton
{
    if (!_selectbutton) {
        _selectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbutton.backgroundColor = HEXCOLOR(0xfe6d6a);
        [_selectbutton setTitle:@"商铺" forState:UIControlStateNormal];
        _selectbutton.frame = CGRectMake(5, 7, 40, 30);
        _selectbutton.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectbutton.layer.cornerRadius = 4;
        _selectbutton.clipsToBounds = YES;
        [_selectbutton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectbutton;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 80, KScreenH-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 50;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _tableView;
}

- (ZFCollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[ZFCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 + 80, 2 + 64, KScreenW - 80 - 4, KScreenH - 64 - 4) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_collectionView registerClass:[ZFCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    if (self.dataSource.count > 0) {
      
        CmgoodsClasstypelist *list = self.dataSource[indexPath.row];
        cell.name.text =list.name;
        
        if (indexPath.row == 0) {
            
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 0) {
        
        _selectIndex = indexPath.row;
        // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
        [self scrollToTopOfSection:_selectIndex animated:YES];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        CmgoodsClasstypelist * list  =  _dataSource[_selectIndex];
        _typeId  = [NSString stringWithFormat:@"%ld",list.typeId];
        
        [self secondClassListWithGoodTypePostRequsetTypeid:_typeId];

    }
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题
- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 
    return self.collectionDatas.count;

 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    Nexttypelist * goodlist = self.collectionDatas[indexPath.row];
    cell.goodlist = goodlist;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenW - 80 - 4 - 4) / 3,
                      (KScreenW - 80 - 4 - 4) / 3 + 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CmgoodsClasstypelist * leftList = self.dataSource[indexPath.section];
        view.title.text = leftList.name;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KScreenW, 30);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Nexttypelist * goodlist = self.collectionDatas[indexPath.item];
    
    NSLog(@"section = %ld,  item = %ld", indexPath.section,indexPath.item);
    DetailFindGoodsViewController * detailVC = [DetailFindGoodsViewController new];
    detailVC.goodsId = [NSString stringWithFormat:@"%ld",goodlist.goodId];
    [self.navigationController pushViewController:detailVC animated:NO];
    
}



#pragma mark -  选择搜索类型
-(void)selectTypeAction :(UIButton *)sender
{
    [YBPopupMenu showRelyOnView:sender titles:TITLES  icons:nil menuWidth:60 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth = 0.5;
        popupMenu.arrowHeight = 5;
        popupMenu.arrowWidth  = 10;
        popupMenu.fontSize = 14;
        popupMenu.delegate = self;
        popupMenu.borderColor = HEXCOLOR(0xfe6d6a);
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",TITLES[index]);
}

#pragma mark -  UISearchBarDelegate选择搜索类型
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索方法");
    HomeSearchResultViewController  * home  = [HomeSearchResultViewController new];
    home.resultsText = searchBar.text;
    [searchBar resignFirstResponder];

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
        self.searchBar.text = @" ";
        [self.searchBar resignFirstResponder];
    }
}


#pragma mark - tableView - 列表网络请求
#pragma mark  - 第一级分类网络请求
-(void)classListTableVieWithGoodTypePostRequset{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getMaxType",zfb_baseUrl] params:nil success:^(id response) {

        if ([response[@"resultCode"] isEqualToString:@"0"]) {
           
            if (self.dataSource.count > 0) {
                
                [self.dataSource removeAllObjects];
                
            }
            
            ClassLeftListModel * list = [ClassLeftListModel mj_objectWithKeyValues:response];
           
            for (CmgoodsClasstypelist * Typelist in list.data.CmGoodsTypeList) {
                
                [self.dataSource addObject:Typelist];
                
            }
  
            [self.tableView reloadData];
            
        }


    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];

}

#pragma mark - collectionView - 列表网络请求
#pragma mark  - 第2级分类网络请求
-(void)secondClassListWithGoodTypePostRequsetTypeid:(NSString *) typeID
{
    NSDictionary * parma = @{
                             
                            @"typeId":typeID,
                             
                             };
    
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getNextType",zfb_baseUrl] params:parma success:^(id response) {
 
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.collectionDatas.count > 0) {
                
                [self.collectionDatas removeAllObjects];
        
            }
            CollectionCategoryModel *model = [CollectionCategoryModel mj_objectWithKeyValues:response];
            for (Nexttypelist  * list in model.data.nextTypeList) {
                
                [self.collectionDatas addObject:list];
            }
         
            
            [self.collectionView reloadData];

        }
    
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
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
