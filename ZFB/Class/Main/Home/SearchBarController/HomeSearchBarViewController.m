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
#import "BYETagListView.h"
//cell
//model
#import "SearchLanelModel.h"


@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate>
{
    TagListView *_tagListView;
    NSMutableArray *_tagArray;
    NSString * _searchText;//搜索关键字
    
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *tagList;//标签
@property (nonatomic, copy)  NSString  *cureHistoryDeleteBtnString;  // 删除按钮字样
@property (nonatomic, copy)  NSString  *inputText;//获取输入框的值
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
    
    //标签视图
    weakSelf(weakself);
    _tagListView = [[TagListView alloc] initWithFrame:CGRectMake(0, 84, KScreenW, 80)];
    [self.view addSubview:_tagListView];
    _tagListView.font = [UIFont systemFontOfSize:14];
    _tagListView.maxLineCount = 3;
    _tagListView.tagCurrentClickTitleBlock = ^(NSString *searchStr){
       
        //直接跳转
        HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
        reslutVC.resultsText = searchStr;
        [weakself.navigationController pushViewController:reslutVC animated:NO];
        weakself.searchBar.text = searchStr;
        NSLog(@"searchStr==%@",searchStr);
    
    };
    _tagListView.tagHeightBlock = ^(CGFloat tagHeight){
        [weakself uploadTagViewHeight:tagHeight];
    };
    _tagListView.tagFontColor = [UIColor whiteColor];
    _tagListView.signalTagColor = HEXCOLOR(0xffcccc);
    _tagListView.GBbackgroundColor = [UIColor whiteColor];
    

 
}
#pragma mark - TableView
- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84+80, KScreenW, KScreenH-64-20-80)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellReuseIdentifier:@"HotSearchCellid"];
    [self.view addSubview:_tableView];
    
}

-(NSMutableArray *)tagList
{
    if (!_tagList) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}
- (void)uploadTagViewHeight:(CGFloat )height {
    /*
     ** 动态修改tagView的高度
     */
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
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 50;
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 5;
}
#pragma mark -  UITableViewDelegate

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString * flag = @"cellFlag";
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        //取消选中状态
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
//                _tableView.hidden = NO;
 
 
//                _tableView.hidden = YES;
 
        cell.contentView.backgroundColor = randomColor;
    }
    //
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
    reslutVC.searchType = self.selectbutton.titleLabel.text;
    reslutVC.resultsText = _searchBar.text;
    [self.navigationController pushViewController:reslutVC animated:NO];\
//    if (indexPath.section > 0) {
//        if (_searchList.count != 0) {
//            
//            reslutVC.number = _searchList[indexPath.row];
//        }else{
//            reslutVC.number = _dataList[indexPath.row];
//        }
//        //_searchController.active = NO;
//        //这样的话就可以实现下边跳转到reslutVC页面的方法了，因为取消了它的活跃，能看到有个动作是直接回到了最初的界面，然后才执行的跳转方法
//        
//        
//        NSLog(@"reslutVC.number = %@",reslutVC.number);
//        //下边这五个方法貌似没什么卵用。会在此时同时打印出来
//        [self willPresentSearchController:_searchController];
//        [self didPresentSearchController:_searchController];
//        [self willDismissSearchController:_searchController];
//        [self didDismissSearchController:_searchController];
//        [self presentSearchController:_searchController];
//
//    }
    
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
        }
        //给标签注入数据
        [_tagListView setTagWithTagArray:[NSMutableArray arrayWithArray:self.tagList]];
        
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
