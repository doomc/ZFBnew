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
@interface ZFSearchBarViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)UITableView * search_TableView;



@end

@implementation ZFSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self settingSearchBarTableView];
    [self settingCustomSearchBar];
    [self settingNavBarLeftItem];
    
    
    
//    // 1.创建热门搜索
//        NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
//        // 2. 创建控制器
//        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索编程语言" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//            // 开始搜索执行以下代码
//            // 如：跳转到指定控制器
//            [searchViewController.navigationController pushViewController:[[ZFSearchDetailViewController alloc] init] animated:YES];
//        }];
//        // 4. 设置代理
//       searchViewController.delegate = self;
//        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
//        searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
//    
//    
    
 
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
    left_btn.frame = CGRectMake(0, 5, 20, 25);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    
    
}
/** 自定义搜索框和放大镜 */
-(void)settingCustomSearchBar
{
    _searchBar= [[ UISearchBar alloc]initWithFrame:CGRectMake(30, 0, KScreenW-60, 35)];
    _searchBar.delegate = self;
    _searchBar.clipsToBounds = YES;
    _searchBar.placeholder = @"请搜索商品或者店铺";
//    [self.searchBar setImage:[UIImage imageNamed:@"search"]
//            forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar becomeFirstResponder];
    _searchBar.tintColor =  HEXCOLOR(0xfe6d6a);
    self.navigationItem.titleView = _searchBar;
    
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

#pragma mark  ----  TableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    
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


-(void)cancel2:(UIButton*)sender{
    
    ZFSearchBarViewController * zfSearchVC= [ZFSearchBarViewController new];
    [self.navigationController pushViewController:zfSearchVC animated:YES];
    
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
