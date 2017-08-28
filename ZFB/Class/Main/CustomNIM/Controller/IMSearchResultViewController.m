//
//  IMSearchResultViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "IMSearchResultViewController.h"
#import "IMSearchResultCell.h"

@interface IMSearchResultViewController ()<UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate>
{
    NSString * searchNum;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UISearchBar * searchBar;
@property (nonatomic , strong) NSMutableArray * searchArray;

@end

@implementation IMSearchResultViewController
#pragma mark --懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar                 = [[UISearchBar alloc]initWithFrame:CGRectMake(50, 0, KScreenW - 2*50, 44)];
        _searchBar.delegate        = self;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        _searchBar.placeholder     = @"搜索好友/群号";
        _searchBar.text = searchNum;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMSearchResultCell" bundle:nil] forCellReuseIdentifier:@"IMSearchResultCell"];
    
    self.navigationItem.titleView = self.searchBar;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSearchResultCell  * cell = [self.tableView dequeueReusableCellWithIdentifier:@"IMSearchResultCell" forIndexPath:indexPath];
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
 
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -  UISearchBarDelegate 搜索代理
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"------开始编辑---%@",searchBar.text);
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"------结束编辑");
    return YES;
}
#pragma mark - 长调用的方法
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText ==== %@",searchText);
    
    searchNum = searchText;
    [self.tableView reloadData];
    
    
}

//点击键盘搜索后的方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索方法");
    [searchBar resignFirstResponder];
    
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
