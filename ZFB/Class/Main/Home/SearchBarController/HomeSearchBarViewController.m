//
//  HomeSearchBarViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomeSearchBarViewController.h"
#import "HomeSearchResultViewController.h"
//view
#import "YBPopupMenu.h"

//cell
#import "MKJTagViewTableViewCell.h"
#import "SearchHistoryCell.h"
//model
#import "SearchLanelModel.h"

static NSString * identyfy = @"MKJTagViewTableViewCell";
static NSString * identyhy = @"SearchHistoryCell";

@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate,SearchHistoryCellDelegate>
{
    NSString * _searchText;//搜索关键字
    NSString * _tagId;//搜索关键字
    
    
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *tagList;//标签
@property (nonatomic, strong) NSMutableArray  *tagIdArr;//标签id

@property (nonatomic ,strong) UIButton * selectbutton;//选择方式
@property (nonatomic ,strong) UIView   * titleView;

@property (nonatomic ,strong) NSMutableArray *historyArray;
@end

@implementation HomeSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getGoodsLanelPOSTRequest];
    
    [self InitInterface];
    
    
    
}
#pragma mark - tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (void)InitInterface{
    
    //nib
    [self.tableView registerNib:[UINib nibWithNibName:identyhy bundle:nil] forCellReuseIdentifier:identyhy];
    [self.tableView registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellReuseIdentifier:identyfy];
    [self.view addSubview:_tableView];
    
    //创建titleView
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    [_titleView addSubview:self.selectbutton];
    [_titleView addSubview:self.searchBar];
    self.navigationItem.titleView = _titleView;
    
    //返回
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(dismissCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView: left_button];
    self.navigationItem.leftBarButtonItems = @[leftItem1];
    
    
}

-(NSMutableArray *)tagList
{
    if (!_tagList) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}
-(NSMutableArray *)tagIdArr
{
    if (!_tagIdArr) {
        _tagIdArr = [NSMutableArray array];
    }
    return _tagIdArr;
}

-(UIButton *)selectbutton
{
    if (!_selectbutton) {
        _selectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbutton.backgroundColor = HEXCOLOR(0xfe6d6a);
        [_selectbutton setTitle:@"商品" forState:UIControlStateNormal];
        _selectbutton.frame = CGRectMake(5, 7, 40, 30);
        _selectbutton.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectbutton.layer.cornerRadius = 4;
        _selectbutton.clipsToBounds = YES;
        [_selectbutton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectbutton;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 2*50, 44)];
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}


#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        //        return 50;
        return [tableView fd_heightForCellWithIdentifier:identyfy configuration:^(id cell) {
            
            [self configCell:cell indexpath:indexPath];
        }];
        
    }
    return 50;
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 1;
    }
    
    return self.historyArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (self.historyArray.count > 0) {
        if (section == 0) {
            
            return  view;
        }
        else{
            UIView * headView =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 40)];
            UILabel* lb_title = [[ UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenW, 40)];
            lb_title.text = @"搜索历史";
            lb_title.font = [UIFont systemFontOfSize:14];
            lb_title.textColor = HEXCOLOR(0x363636);
            [headView addSubview:lb_title];
            view = headView;
        }
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.historyArray.count > 0) {
        CGFloat height = 0.0001 ;
        if (section ==0 ) {
            return height;
        }
        return 40;

    }
    return 0;
  
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = nil;
    if (self.historyArray.count > 0) {
        
        if (section == 0) {
            return  view;
        }
        else{
            UIButton * footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            footBtn.frame = CGRectMake(0, 0, KScreenW, 40);
            [footBtn setTitle:@"清空历史记录~" forState:UIControlStateNormal];
            footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [footBtn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal];
            [footBtn addTarget:self action:@selector(clearingAllhistoryData) forControlEvents:UIControlEventTouchUpInside];
            view = footBtn;
        }
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.historyArray.count > 0) {
        
        if (section == 0) {
        
            return 0.001;
        }
        return 44;

    }
    return 0;
}
#pragma mark -  UITableViewDelegate
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MKJTagViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyfy forIndexPath:indexPath];
        
        [self configCell:cell indexpath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        
        SearchHistoryCell *historyCell = [self.tableView dequeueReusableCellWithIdentifier:identyhy forIndexPath:indexPath];
        historyCell.delegate = self;
        historyCell.row = indexPath.row;
        historyCell.lb_historyName.text = self.historyArray[indexPath.row];
        return historyCell;
    }
}

- (void)configCell:(MKJTagViewTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    [cell.tagView removeAllTags];
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(15, 10, 10, 15);
    cell.tagView.lineSpacing = 10;
    cell.tagView.interitemSpacing = 20;
    cell.tagView.singleLine = NO;
    // 给出两个字段，如果给的是0，那么就是变化的,如果给的不是0，那么就是固定的
    //        cell.tagView.regularWidth = 80;
    //        cell.tagView.regularHeight = 30;
    
    NSArray * arr = [NSArray arrayWithArray:self.tagList];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
        
        tag.font = [UIFont systemFontOfSize:14];
        tag.textColor = HEXCOLOR(0xfefefe);
        tag.bgColor = HEXCOLOR(0xffcccc);
        tag.cornerRadius = 4;
        tag.enable = YES;
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        [cell.tagView addTag:tag];
    }];
    //
    cell.tagView.didTapTagAtIndex = ^(NSUInteger index)
    {
        _searchText =  self.tagList[index];
        _tagId  =  self.tagIdArr[index];
        
        HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
        reslutVC.searchType = self.selectbutton.titleLabel.text;
        reslutVC.resultsText = _searchBar.text = _searchText;
        reslutVC.labelId = _tagId;
       
        [self.navigationController pushViewController:reslutVC animated:NO];
        NSLog(@"点击了%ld  === %@ =====%@id ",index,_searchText,_tagId);
 
        [self.historyArray addObject:_searchText];
        
        BBUserDefault.searchHistoryArray = self.historyArray;//存到本地
    };
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld  ---- %ld",indexPath.section ,indexPath.row);
    
    NSString * searchText = self.historyArray[indexPath.row];
    if (indexPath.section == 1) {
        //标签视图
        HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
        reslutVC.searchType = self.selectbutton.titleLabel.text;
        reslutVC.resultsText = searchText;
        [self.navigationController pushViewController:reslutVC animated:NO];
        
    }
    
}


#pragma mark  - getProSearch 关键字搜索
//以下的两个方法必须设置.searchBar.delegate 才可以
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
    return YES;
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"正在编辑--- %@",text);
    
    return YES;
}

//当搜索框中的内容发生改变时会自动进行搜索,这个是经常用的
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchText = searchText;
}
//在键盘中的搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了搜索");
    
    if ([searchBar.text isEqualToString:@""]) {
        JXTAlertController * alertavc =[JXTAlertController alertControllerWithTitle:@"提示" message:@"还有没有搜索内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertavc addAction:sureAction];
        
        [self presentViewController:alertavc animated:YES completion:nil];
        
    }else{
        
        //push操作
        HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
        reslutVC.searchType = self.selectbutton.titleLabel.text;
        reslutVC.resultsText = searchBar.text;
        [self.navigationController pushViewController:reslutVC animated:NO];
        
        //关键字 save 到本地
        NSMutableArray * tempArr = [NSMutableArray array];
        if (self.historyArray) {
            
            tempArr = [self.historyArray mutableCopy];
        }
        [tempArr addObject:searchBar.text];
        
        BBUserDefault.searchHistoryArray = tempArr;//存到本地
    }
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
    
    [_selectbutton setTitle:TITLES[index] forState:UIControlStateNormal];
    
}


#pragma mark  - getGoodsLanel用于查找商品-商品标签
-(void)getGoodsLanelPOSTRequest
{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsLanel",zfb_baseUrl] params:nil success:^(id response) {
        
        SearchLanelModel * searchLanel = [SearchLanelModel mj_objectWithKeyValues:response];
        for (Cmgoodslanel * lanel in searchLanel.data.cmGoodsLanel) {
            
            [self.tagList addObject:lanel.labelName];
            [self.tagIdArr addObject:lanel.labelId];
        }
        [self.tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        NSLog(@"error=====%@",error);
    }];
}

//重新从本地获取历史记录
-(void)reloadHistory
{
    for (NSString * title in  BBUserDefault.searchHistoryArray) {
      
        [self.historyArray addObject: title];
    }
    [self.tableView reloadData];
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
        
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}
//刷新历史记录
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.historyArray.count > 0) {

        [self.historyArray removeAllObjects];
    }
    [self reloadHistory];

}
#pragma mark - 删除单个数据
-(void)deleteSingleDataRow:(NSUInteger)row
{
    [self.historyArray removeObjectAtIndex:row];
    [self.tableView reloadData];
}
//清空历史记录
-(void)clearingAllhistoryData
{
    NSLog(@"%@",self.historyArray);
    if (self.historyArray.count > 0) {
        BBUserDefault.searchHistoryArray = nil;
        [self.historyArray removeAllObjects];
        [self.tableView reloadData];
    }
}
-(void)dismissCurrentPage
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSLog(@"返回上一页");
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
