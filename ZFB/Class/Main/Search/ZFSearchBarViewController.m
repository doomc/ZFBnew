//
//  ZFSearchBarViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSearchBarViewController.h"
#import "ZFSearchDetailViewController.h"
#import "PYSearch.h"
@interface ZFSearchBarViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDataSource>

@property (nonatomic , strong) PYSearchViewController * searchBarViewController;
@property (nonatomic , strong) UITableView * search_TableView;
@property (nonatomic , strong) NSMutableArray  * dataArray;
@property (nonatomic , strong) NSArray  * hotArray;



@end

@implementation ZFSearchBarViewController
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0 ; i< 6; i ++) {
            NSString *number = [NSString stringWithFormat:@"%d",i];
            [tempArray addObject:number];
        }
        _dataArray = tempArray.copy;

    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self settingSearchBarTableView];
    
    [self settingNavBarLeftItem];
    
    self.hotArray = [NSArray array];

    
    [self PYSearchViewControllerInit];
    

   
}
-(void)PYSearchViewControllerInit
{
//    self.hotArray = @[@"服装", @"热搜", @"iphone8", @"手机", @"电脑", @"展富宝", @"AAABBB"];
//
//    PYSearchViewController * searchVC= [PYSearchViewController searchViewControllerWithHotSearches:self.hotArray searchBarPlaceholder:@"来搜索啊"];
//    searchVC.dataSource = self;
//    searchVC.searchResultShowMode = PYSearchResultShowModeCustom;
//    searchVC.searchResultController = [[ZFSearchDetailViewController alloc] init];
//    // Set hotSearchStyle
//    searchVC.hotSearchStyle = PYHotSearchStyleNormalTag;
//    // Set searchHistoryStyle
//    searchVC.searchHistoryStyle = PYSearchHistoryStyleCell;
//    // Set searchHistoriesCachePath
//    searchVC.searchHistoriesCachePath = @"The cache path";
//    // Set searchSuggestionHidden
//    searchVC.searchSuggestionHidden = NO;
//    
//    //自定义
//    
//    self.navigationItem.titleView = searchVC.searchBar;

}
/**初始化搜索列表 */
-(void)settingSearchBarTableView
{
    self.search_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH -64) style:UITableViewStyleGrouped];
    [self.view addSubview:_search_TableView];
    self.search_TableView .delegate = self;
    self.search_TableView.dataSource = self;
    

}

/**定义导航栏返回*/
-(void)settingNavBarLeftItem
{
    UIButton* left_btn   =[UIButton buttonWithType:UIButtonTypeCustom];
    [left_btn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    left_btn.frame = CGRectMake(0, 5, 22, 22);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem =leftItem;

}

#pragma mark  -  UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  _hotArray.count;
    }
    
    return   self.dataArray.count  ;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;

 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜素完毕
            // 显示建议搜索结果
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // 返回
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}



-(void)cancel:(UIButton*)sender{
  
    NSLog(@"%@",sender);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
