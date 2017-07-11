//
//  HomeSearchBarViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "HomeSearchBarViewController.h"
#import "HomeSearchResultViewController.h"
#import "YBPopupMenu.h"

#define TITLES @[@"门店",@"商品"]
@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *dataList;//全部数据的array
@property (nonatomic, strong) NSMutableArray  *searchList;//search到的array
@property (nonatomic, copy) NSString *cureHistoryDeleteBtnString;  // 删除按钮字样
@property (nonatomic, copy) NSString *inputText;//获取输入框的值
@property (nonatomic ,strong) UIButton * selectbutton;//选择方式


@end

@implementation HomeSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
        _searchController.obscuresBackgroundDuringPresentation = NO;
    }
    self.definesPresentationContext = YES;
    [self createTableView];
    [self createSearch];
    
    NSArray *arr1 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    NSArray *arr2 = @[];
    
    _dataList = [NSMutableArray arrayWithArray:arr1];//数据数组
    _searchList = [NSMutableArray arrayWithArray:arr2];//search到的数组
    
    
//    UIBarButtonItem * left  =[[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(dismissCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView: left_button];

    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:self.selectbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem1,leftItem2];
    
}
-(UIButton*)set_leftButton
{
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(dismissCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    return left_button;
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
        [_selectbutton setTitle:@"商铺" forState:UIControlStateNormal];
        _selectbutton.frame = CGRectMake(5, 7, 40, 30);
        _selectbutton.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectbutton.layer.cornerRadius = 4;
        _selectbutton.clipsToBounds = YES;
        [_selectbutton addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectbutton;
}


#pragma mark- TableView
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
        //        _tableView.hidden = NO;
        return [self.searchList count];
    }else{
        //        _tableView.hidden = YES;
        return [self.dataList count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        //取消选中状态
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/256.0f green:arc4random()%255/256.0f  blue:arc4random()%255/256.0f  alpha:1];
    }
    if (self.searchController.active) {
        //        _tableView.hidden = NO;
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        //        _tableView.hidden = YES;
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    //
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
    if (_searchList.count != 0) {
        reslutVC.number = _searchList[indexPath.row];
    }else{
        reslutVC.number = _dataList[indexPath.row];
    }
    //_searchController.active = NO;
    //这样的话就可以实现下边跳转到reslutVC页面的方法了，因为取消了它的活跃，能看到有个动作是直接回到了最初的界面，然后才执行的跳转方法
    
    [self.navigationController pushViewController:reslutVC animated:NO];
    
    NSLog(@"reslutVC.number = %@",reslutVC.number);
    //下边这五个方法貌似没什么卵用。会在此时同时打印出来
    [self willPresentSearchController:_searchController];
    [self didPresentSearchController:_searchController];
    [self willDismissSearchController:_searchController];
    [self didDismissSearchController:_searchController];
    [self presentSearchController:_searchController];
    
}


// 6.添加多个按钮在Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _cureHistoryDeleteBtnString = @"删除";
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:_cureHistoryDeleteBtnString handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"删除本行");
        /*
         // 1.删除数据源
         [self.dataArray removeObject:lastModel];
         
         // 2.删除数据库
         NSArray *lastPointModels = [manager selectModelArrayInDatabase:localDatabaseName table:@"tcmt_cure_acupoints" modelName:@"LastPointModel" selectFactor:[NSString stringWithFormat:@"WHERE cure_id = '%@'", lastModel.cure_id]];
         for (LastPointModel *lastPointModel in lastPointModels) {
         [manager deleteModelWithDatabase:localDatabaseName table:@"tcmt_cure_acupoints" model:lastPointModel];
         
         }
         [manager deleteModelWithDatabase:localDatabaseName table:@"tcmt_cure" model:lastModel];
         
         
         // 3.更新UI
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         
         // 4.是否显示infoLabel
         if (self.dataArray.count == 0) {
         self.infoLabel.text = _cureHistoryInfoLabelString;
         self.infoLabel.hidden = NO;
         }
         */
    }];
    return @[deleteRowAction];
}



#pragma mark- SearchController
- (void)createSearch{

    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;//*****这个很重要，一定要设置并引用了代理之后才能调用searchBar的常用方法*****
    _searchController.dimsBackgroundDuringPresentation = NO;//是否添加半透明覆盖层
    _searchController.hidesNavigationBarDuringPresentation = NO;//是否隐藏导航栏

//    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x + 50, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    [_searchController.searchBar sizeToFit];
    
    _searchController.searchBar.placeholder = @"造作啊~";
    NSLog(@"%f",_searchController.searchBar.frame.size.width);
    [[[_searchController.searchBar.subviews.firstObject subviews] firstObject] removeFromSuperview];// 直接把背景imageView干掉。在iOS8,9是没问题的，7没测试过。

    UIView * navbarView = [[UIView alloc]initWithFrame:
                           CGRectMake(0, 0, KScreenW - 60, 44)];
    //    navbarView.backgroundColor = [UIColor whiteColor];
    navbarView.clipsToBounds = YES;
    navbarView.layer.cornerRadius = 4;
    
    [navbarView addSubview:_searchController.searchBar];
    [navbarView addSubview:self.selectbutton];
    
    self.navigationItem.titleView = _searchController.searchBar;
}



//展示搜索结果
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
    searchController.searchBar.showsCancelButton = YES;
    UIView * view = [searchController.searchBar.subviews objectAtIndex:0];
    for (UIView *subView in view.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *bar = (UIButton *)subView;
            
            [bar setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
            
            [bar setTitle:@"泥煤的" forState:UIControlStateNormal];
        }
    }
    
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}


//
#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}


//以下的两个方法必须设置_searchController.searchBar.delegate 才可以
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始编辑");
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"结束编辑");
    return YES;
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"正在编辑");
    return YES;
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
        popupMenu.borderColor = [UIColor redColor];
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",TITLES[index]);
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
