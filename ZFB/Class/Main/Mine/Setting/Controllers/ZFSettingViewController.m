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
#import "ZFBaseNavigationViewController.h"

 

static NSString * settingCellid = @"ZFSettingCellid";
@interface ZFSettingViewController ()<UITableViewDelegate,UITableViewDataSource,NIMLoginManagerDelegate>
{
    NSArray * _titleArr;
    NSArray * _imagesArr;
    NSString  * _cacheSize;
    
    
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * login_btn;

@end

@implementation ZFSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.title = @"设置";
    _titleArr  = @[@"我的信息",@"修改密码",@"手机号码",@"清楚缓存",@"客服热线",@"招商入驻"];
    _imagesArr = @[@"setting_message",@"setting_ps",@"setting_phone",@"setting_cache",@"setting_calling",@"setting_shakehand",];
    
    [self.view addSubview:self.tableView];
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

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    _login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _login_btn.titleLabel.font=SYSTEMFONT(14);
    [_login_btn setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    _login_btn.titleLabel.textAlignment = NSTextAlignmentRight;
    _login_btn.frame =CGRectMake(0, 0, 80, 22);
    
    return _login_btn;
}
//设置右边事件 didClickChangeLoginStatus
-(void)right_button_event:(UIButton*)sender{
    
    [self didClickChangeLoginStatus:sender];
    
    NSLog(@"退出登录");
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
    else if (indexPath.row == 2) {
        if (BBUserDefault.isLogin == 1) {
            settcell.lb_detailTitle.text = [NSString stringWithFormat:@"已绑定%@",BBUserDefault.userPhoneNumber];
        }else{
             settcell.lb_detailTitle.text = @"";
        }

    }
    else if (indexPath.row == 3) {
         //读取缓存大小
        settcell.lb_detailTitle.text = _cacheSize = [NSString stringWithFormat:@"%.2fM",[settcell readCacheSize]];
        NSLog(@"当前显示的 缓存 = %@ = %.f",_cacheSize,[settcell readCacheSize]);
    }
    else if (indexPath.row == 4) {
        //客服热线
        settcell.lb_detailTitle.text = @"023-67685157-8005";
    }
    else if (indexPath.row == 5) {
        //客服热线
        settcell.lb_detailTitle.text =  @"400-666-2001";
    }
    return settcell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    
    if (indexPath.row == 0  ) {
        ZFSettingHeadViewController * settingVC = [[ZFSettingHeadViewController alloc]init];
        settingVC.userImgAttachUrl = _userImgAttachUrl;
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }else if (indexPath.row == 1) {
        ForgetPSViewController *chagePSVC =[[ForgetPSViewController alloc]init];
        [self.navigationController pushViewController:chagePSVC animated:YES];
        
    }else if (indexPath.row == 2) {
        
        
    }else if (indexPath.row == 3) {
    
        ZFSettingCell * settcell  = (ZFSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
        JXTAlertController * jxt = [JXTAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@,确认清除缓存吗",_cacheSize] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * left = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * right = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [settcell clearingCache];//清除所有缓存;
            [self.tableView reloadData];
            
        }];
        [jxt addAction:left];
        [jxt addAction:right];
        [self presentViewController:jxt animated:YES completion:^{  }];
  
    }
    
}
///清除缓存
-(void)clearingCache
{
    [SDCycleScrollView  clearImagesCache];//清除缓存
    [self clearAllUserDefaultsData];
}
 
- (void)clearAllUserDefaultsData
{
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

#pragma mark - didClickChangeLoginStatus 切换登录状态
-(void)didClickChangeLoginStatus:(UIButton*)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"退出登录"]) {  // _isLogin 设置成全局 在登录的时候做保存判断；
        JXTAlertController * jxt = [JXTAlertController alertControllerWithTitle:@"提示信息" message:@"退出后您的数据将会被清除，确认要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * left = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * right = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.view makeToast:@"数据已清空" duration:2.0 position:@"center"];
            [sender setTitle:@"登陆" forState:UIControlStateNormal ];
            [self clearingCache];//清除所有缓存;
            BBUserDefault.isLogin = 0;
            BBUserDefault.token = @"";
            BBUserDefault.cmUserId = @"";
            [self loginOutAction];
            [self.tableView reloadData];


        }];
        [jxt addAction:left];
        [jxt addAction:right];
        [self presentViewController:jxt animated:YES completion:^{  }];
        
    }
    
    if ([sender.titleLabel.text isEqualToString:@"登陆"]) {
        LoginViewController * logVC = [[LoginViewController alloc]init ];
        ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:logVC];
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];

        }];
        
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    //默认为登录状态后面根据后台数据返回
    if (BBUserDefault.isLogin == 1) {
        
        [self.login_btn setTitle:@"退出登录" forState:UIControlStateNormal];
        
    }else{
        [self.login_btn setTitle:@"登陆" forState:UIControlStateNormal ];
    }
    
}


///登出
-(void)loginOutAction
{
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        NSLog(@" %@ = error",error);
    }];
}
@end
