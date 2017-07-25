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

@interface HomeSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate,SearchTypeViewDelegate >


@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray  *dataList;//全部数据的array
@property (nonatomic, strong) NSMutableArray  *searchList;//search到的array

@property (nonatomic ,strong) UIButton * selectbutton;//搜索选择方式
@property (nonatomic ,strong) SearchTypeView * searchTypeHeaderView;//选择方式
@property (nonatomic ,strong) UIView * titleView;
@property (nonatomic ,strong) UIView * popBgView;//全屏背景
@property (nonatomic ,strong) SearchTypeCollectionView * searchCollectionView;//品牌列表

@property (nonatomic, strong) NSArray  *distenceList;
@property (nonatomic, strong) NSArray  *salesList;
@property (nonatomic, strong) NSArray  *priceList;


@end


@implementation HomeSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _priceList = @[@"0-290",@"300-500",@"1000+",@"50000+"];
    _distenceList = @[@"附近", @"1km", @"3km", @"5km",@"10km",@"全城"];
    _salesList = @[@"智能排序", @"离我最近", @"好评优先", @"人气最高"];

    
    //创建titleView
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView addSubview:self.selectbutton];
    [_titleView addSubview:self.searchBar];
    
    //加载xib
    [self.tableView registerNib:[UINib nibWithNibName:@"GuessCell" bundle:nil] forCellReuseIdentifier:@"resultCellid"];
    _searchTypeHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SearchTypeView" owner:self options:nil].lastObject;
    _searchTypeHeaderView.frame = CGRectMake(0, 64, KScreenW, 40);
    _searchTypeHeaderView.delegate = self;
    
    //添加视图
    [self.view addSubview: self.tableView];
    [self.view addSubview: _searchTypeHeaderView];
    


}

//选择品牌列表
-(void)popCollectionView
{
    _popBgView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, KScreenW, KScreenH)];
    _popBgView.backgroundColor =  RGBA(0, 0, 0, 0.15);
    [self.view addSubview:_popBgView];
    [self.tableView bringSubviewToFront:_popBgView];
    
 
    //创建集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake( (KScreenW - 120) / 2,  30);
    _searchCollectionView = [[SearchTypeCollectionView alloc]initWithFrame:CGRectMake(0,64+40, KScreenW, 230) collectionViewLayout:layout];
    _searchCollectionView.showsVerticalScrollIndicator = NO;
    [_popBgView addSubview:_searchCollectionView];
 
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_popBgView removeFromSuperview];
    [_searchCollectionView  removeFromSuperview];
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

#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44  , KScreenW, KScreenH-64-44 ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIButton *)selectbutton
{
    if (!_selectbutton) {
        _selectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbutton.backgroundColor = HEXCOLOR(0xfe6d6a);
        [_selectbutton setTitle:@"门店" forState:UIControlStateNormal];
        _selectbutton.frame = CGRectMake(5, 7, 40, 30);
        _selectbutton.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectbutton.layer.cornerRadius = 4;
        _selectbutton.clipsToBounds = YES;
        [_selectbutton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectbutton;
}
#pragma mark -  选择搜索类型
-(void)selectTypeAction :(UIButton *)sender
{
    [sender setTag:1001];

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
    NSLog(@" %@ 1001",TITLES[index]);
 

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 1;
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GuessCell * resultCell = [self.tableView dequeueReusableCellWithIdentifier:@"resultCellid" forIndexPath:indexPath];
    return resultCell;
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索方法");
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
