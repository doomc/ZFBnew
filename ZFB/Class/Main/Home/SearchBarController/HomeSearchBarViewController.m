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

//model
#import "SearchLanelModel.h"

static NSString * identyfy = @"MKJTagViewTableViewCell";
@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate>
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


@end

@implementation HomeSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self getGoodsLanelPOSTRequest];
    
    [self createTableView];
    
    //创建titleView
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 40, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView addSubview:self.selectbutton];
    [_titleView addSubview:self.searchBar];
    self.navigationItem.titleView = _titleView;

    //返回时间
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(dismissCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView: left_button];
    self.navigationItem.leftBarButtonItems = @[leftItem1];
    


 
}
#pragma mark - TableView
- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellReuseIdentifier:@"HotSearchCellid"];
    [self.tableView registerNib:[UINib nibWithNibName:identyfy bundle:nil] forCellReuseIdentifier:identyfy];
    [self.view addSubview:_tableView];
    
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


-(void)dismissCurrentPage
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSLog(@"返回上一页");
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
    return 5;
}
#pragma mark -  UITableViewDelegate

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * flag = @"cellFlag";

    if (indexPath.section == 0) {
        MKJTagViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyfy forIndexPath:indexPath];
      
        [self configCell:cell indexpath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        //取消选中状态
  
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = randomColor;
    
    }
 
    return cell;
}

- (void)configCell:(MKJTagViewTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    [cell.tagView removeAllTags];
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(20, 20, 20, 20);
    cell.tagView.lineSpacing = 20;
    cell.tagView.interitemSpacing = 30;
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
    
    };
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        //标签视图
        HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
        reslutVC.searchType = self.selectbutton.titleLabel.text;
        reslutVC.resultsText = _searchBar.text;
        [self.navigationController pushViewController:reslutVC animated:NO];

    }

}






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
 
    HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
    reslutVC.searchType = self.selectbutton.titleLabel.text;
    reslutVC.resultsText = searchBar.text;
    [self.navigationController pushViewController:reslutVC animated:NO];

}



#pragma mark  - getProSearch 关键字搜索




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
