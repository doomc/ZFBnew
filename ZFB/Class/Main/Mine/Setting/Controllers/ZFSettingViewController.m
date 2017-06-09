//
//  ZFSettingViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingViewController.h"
#import "ZFSettingHeadViewController.h"
#import "ForgetPSViewController.h"
#import "ZFSettingCell.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

static NSString * settingCellid = @"ZFSettingCellid";
@interface ZFSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _titleArr;
    NSArray * _imagesArr;
    BOOL _isLogin;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * login_btn;

@end

@implementation ZFSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    _isLogin =  YES; //默认为登录状态后面根据后台数据返回
    BBUserDefault.isLogin = _isLogin;
    self.title = @"设置";
    _titleArr  = @[@"我的信息",@"修改密码",@"手机号码",@"清楚缓存",@"客服热线",@"招商入驻"];
    _imagesArr = @[@"setting_message",@"setting_ps",@"setting_phone",@"setting_cache",@"setting_calling",@"setting_shakehand",];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.login_btn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFSettingCell" bundle:nil] forCellReuseIdentifier:settingCellid];
    
    
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64 - 60) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIButton *)login_btn
{
    if (!_login_btn) {
        NSString * title = @"退出登录";
        _login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _login_btn.frame = CGRectMake(40, KScreenH - 64 - 60 - 20, KScreenW - 40-40, 40);
        [_login_btn setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        [_login_btn setTitle:title forState:UIControlStateNormal];
        _login_btn.layer.cornerRadius = 5;
        _login_btn.clipsToBounds = YES;
        [_login_btn addTarget:self action:@selector(didClickChangeLoginStatus:) forControlEvents:UIControlEventTouchUpInside];
        _login_btn.titleLabel .font = SYSTEMFONT(14);
    }
   return  _login_btn;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSettingCell * settcell = [self.tableView dequeueReusableCellWithIdentifier:settingCellid forIndexPath:indexPath];
    
    settcell.lb_detailTitle.text = _titleArr[indexPath.row];
    settcell.lb_title.text = _titleArr[indexPath.row];
    settcell.img_iconView.image = [UIImage imageNamed:_imagesArr[indexPath.row]];
    settcell.selectionStyle = UITableViewCellSelectionStyleNone;
    settcell.img_detailIcon.hidden = YES;
 
    if (indexPath.row <2 ) {
        
        settcell.lb_detailTitle.text =@"";
        settcell.img_detailIcon.hidden = NO;

    }

    return settcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);

    if (indexPath.row == 0  ) {
        
        ZFSettingHeadViewController * settingVC = [[ZFSettingHeadViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }if (indexPath.row == 1) {
        ForgetPSViewController *chagePSVC =[[ForgetPSViewController alloc]init];
        [self.navigationController pushViewController:chagePSVC animated:YES];
    }
}

#pragma mark - didClickChangeLoginStatus 切换登录状态
-(void)didClickChangeLoginStatus:(UIButton*)sender{
//    BBUserDefault.isLogin = _isLogin;
//    sender.selected = !sender.selected;
//    //设置登录状态
//    if (sender.selected == YES) {
//        [sender setTitle:@"退出登录" forState:UIControlStateNormal];
//
//        
//    }else{
//        [sender setTitle:@"登陆" forState:UIControlStateNormal ];
//        
//        
//    }
    
    if (BBUserDefault.isLogin == YES) {  // _isLogin 设置成全局 在登录的时候做保存判断；
        [sender setTitle:@"退出登录" forState:UIControlStateNormal];
        [WJYAlertView showTwoButtonsWithTitle:@"信息提示" Message:@"退出后您的数据将会被清除，确认要退出吗？" ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
            
        } ButtonType:WJYAlertViewButtonTypeWarn ButtonTitle:@"确认" Click:^{
            
            [self.view makeToast:@"数据已清空" duration:2.0 position:@"center"];
            [sender setTitle:@"马上去登陆" forState:UIControlStateNormal ];
            
        }];
        _isLogin = NO;
        BBUserDefault.isLogin =_isLogin;

    }else{
        
        if ([sender.titleLabel.text isEqualToString:@"马上去登陆"]) {
            LoginViewController * logVC = [[LoginViewController alloc]init ];
            BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:logVC];
            [self presentViewController:nav animated:NO completion:^{
                
                [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
                [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
            }];
            
        }

    }

    
    
  
}
@end