//
//  ZFSearchDetailViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright  © 2017年 com.zfb. All rights reserved.
//  搜索详情

#import "ZFSearchDetailViewController.h"

@interface ZFSearchDetailViewController ()<UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic,strong)UIButton* shakehanderRight_btn;

@end

@implementation ZFSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingCustomSearchBar];

    
    
}
-(UIButton *)set_rightButton
{
    self.shakehanderRight_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shakehanderRight_btn.frame = CGRectMake(KScreenW - 50 -40, 0, 40, 40);

    //把button的视图交给Item
    UIBarButtonItem * shakeItem = [[UIBarButtonItem alloc] initWithCustomView:self.shakehanderRight_btn];
    //添加到导航项的左按钮
    self.navigationItem.rightBarButtonItem = shakeItem;
    return self.shakehanderRight_btn;
}
/** 自定义搜索框和放大镜 */
-(void)settingCustomSearchBar
{
    _searchBar= [[ UISearchBar alloc]initWithFrame:CGRectMake(30, 0, KScreenW-60, 35)];
    _searchBar.delegate = self;
    _searchBar.clipsToBounds = YES;
    _searchBar.placeholder = @"搜索";
    //    [self.searchBar setImage:[UIImage imageNamed:@"search"]
    //            forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar becomeFirstResponder];
    _searchBar.tintColor =  HEXCOLOR(0x363636);
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
