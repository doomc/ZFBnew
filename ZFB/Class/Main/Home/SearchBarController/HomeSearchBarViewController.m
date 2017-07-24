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

#define WeakSelf(type)  __weak typeof(type) weak##type = type;
@interface HomeSearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YBPopupMenuDelegate>
{
        TagListView *_tagListView;
        NSMutableArray *_tagArray;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *dataList;//全部数据的array
@property (nonatomic, strong) NSMutableArray  *searchList;//search到的array
@property (nonatomic, copy)  NSString  *cureHistoryDeleteBtnString;  // 删除按钮字样
@property (nonatomic, copy)  NSString  *inputText;//获取输入框的值
@property (nonatomic ,strong) UIButton * selectbutton;//选择方式
@property (nonatomic ,strong) UIView   * titleView;
@property (nonatomic ,strong) NSArray  * hotArray;


@end

@implementation HomeSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self createTableView];

    _hotArray =  @[@"2123",@"裤子裤子",@"裤子裤子:",@"衣服服",@"衣服2:",@"裤子裤子:",@"衣服服",@"衣服2:"];
    _tagArray = [NSMutableArray arrayWithArray:_hotArray];

    
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
     WeakSelf(self);
    _tagListView = [[TagListView alloc] initWithFrame:CGRectMake(0, 84, KScreenW, 80)];
    [self.view addSubview:_tagListView];
    _tagListView.font = [UIFont systemFontOfSize:13];
    _tagListView.maxLineCount = 3;
    _tagListView.tagCurrentClickTitleBlock = ^(NSString *searchStr){
        NSLog(@"searchStr==%@",searchStr);
    };
    _tagListView.tagHeightBlock = ^(CGFloat tagHeight){
        [weakself uploadTagViewHeight:tagHeight];
    };
    _tagListView.tagFontColor = [UIColor whiteColor];
    _tagListView.signalTagColor = HEXCOLOR(0xffcccc);
    _tagListView.GBbackgroundColor = [UIColor whiteColor];
    
    //给标签注入数据
    [_tagListView setTagWithTagArray:_tagArray];


    
}
#pragma mark - TableView
- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84+80, KScreenW, KScreenH-64-20-80)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellReuseIdentifier:@"HotSearchCellid"];
    [self.view addSubview:_tableView];
    
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
        [_selectbutton setTitle:@"商铺" forState:UIControlStateNormal];
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
        _searchBar.placeholder =@"搜索";
    }
    return _searchBar;
}


#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 60;
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 5;
}
#pragma mark -  UITableViewDelegate

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString * flag = @"cellFlag";
//    static NSString * hotflag = @"HotSearchCellid";

//    if (indexPath.section == 0) {
//        HotSearchCell * hotCell = [self.tableView dequeueReusableCellWithIdentifier:hotflag forIndexPath:indexPath];
//       
//        return hotCell;
//    }
//    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        //取消选中状态
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
//                _tableView.hidden = NO;
        [cell.textLabel setText:self.searchList[indexPath.row]];
 
//                _tableView.hidden = YES;
        [cell.textLabel setText:self.dataList[indexPath.row]];
        cell.contentView.backgroundColor = randomColor;
    }
    //
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSearchResultViewController * reslutVC = [[HomeSearchResultViewController alloc] init];
    [self.navigationController pushViewController:reslutVC animated:NO];

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






//展示搜索结果
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
//    searchController.searchBar.showsCancelButton = YES;
    UIView * view = [searchController.searchBar.subviews objectAtIndex:0];
    for (UIView *subView in view.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *bar = (UIButton *)subView;
            
            [bar setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal];
            
            [bar setTitle:@"泥煤的" forState:UIControlStateNormal];
        }
    }
    
    NSString *searchString = [self.searchBar text];
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
        popupMenu.borderColor = HEXCOLOR(0xfe6d6a);
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
