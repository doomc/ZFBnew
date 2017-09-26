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
#import "PayPassWordSettingViewController.h"
#import "NTESService.h"
static NSString * settingCellid = @"ZFSettingCellid";
@interface ZFSettingViewController ()<UITableViewDelegate,UITableViewDataSource,NIMLoginManagerDelegate>
{
    NSArray * _titleArr1;
    NSArray * _titleArr2;
    NSArray * _titleArr3;
    NSArray * _imagesArr1;
    NSArray * _imagesArr2;
    NSArray * _imagesArr3;
    NSString  * _cacheSize;
    
    
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * login_btn;

@end

@implementation ZFSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"设置";
    _titleArr1  = @[@"我的信息",@"修改密码",@"支付设置",@"分享圈"];
    _titleArr2  = @[@"手机号码",@"清楚缓存"];
    _titleArr3  = @[@"客服热线",@"招商入驻"];

    _imagesArr1 = @[@"setting_message",@"setting_ps",@"setting_ps",@"setting_phone"];
    _imagesArr2 = @[@"setting_phone",@"setting_cache"];
    _imagesArr3 = @[@"setting_calling",@"setting_shakehand",];

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
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       
        return _titleArr1.count;
 
    }else if (section ==1)
    {
        return _titleArr2.count;

    }
    return _titleArr3.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  * headview = nil;
    if (headview == nil) {
        if (section > 0) {
            headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
            headview.backgroundColor = RGBA(244, 244, 244, 1);
        }
    }
    return headview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZFSettingCell * settingcell = [self.tableView dequeueReusableCellWithIdentifier:settingCellid forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row <3 ) {
            
            settingcell.lb_detailTitle.text =@"";
            settingcell.img_detailIcon.hidden = NO;
            
        }
        settingcell.lb_title.text = _titleArr1[indexPath.row];
        settingcell.lb_detailTitle.text =@"";
        settingcell.img_iconView.image = [UIImage imageNamed:_imagesArr1[indexPath.row]];
        
        return settingcell;
    }else if (indexPath.section ==1)
    {
        settingcell.img_detailIcon.hidden = YES;
        settingcell.lb_title.text = _titleArr2[indexPath.row];
        settingcell.img_iconView.image = [UIImage imageNamed:_imagesArr2[indexPath.row]];
        if (indexPath.row == 0)
        {
            if (BBUserDefault.isLogin == 1) {
                settingcell.lb_detailTitle.text = [NSString stringWithFormat:@"已绑定%@",BBUserDefault.userPhoneNumber];
            }else{
                settingcell.lb_detailTitle.text = @"";
            }
        }else {
            //读取缓存大小
            settingcell.lb_detailTitle.text = _cacheSize = [NSString stringWithFormat:@"%.2fM",[settingcell readCacheSize]];
            NSLog(@"当前显示的 缓存 = %@ = %.f",_cacheSize,[settingcell readCacheSize]);
        }
        return settingcell;

    }else{
        settingcell.img_detailIcon.hidden = YES;
        settingcell.lb_title.text = _titleArr3[indexPath.row];
        settingcell.img_iconView.image = [UIImage imageNamed:_imagesArr3[indexPath.row]];
        if (indexPath.row == 0) {
            //客服热线
            settingcell.lb_detailTitle.text = @"023-67685157-8005";
 
        }else{
        //客服热线
        settingcell.lb_detailTitle.text =  @"400-666-2001";

        return settingcell;
        }
   
    }

    return settingcell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sectin = %ld,row = %ld",indexPath.section ,indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0  ) {//我的信息
            ZFSettingHeadViewController * settingVC = [[ZFSettingHeadViewController alloc]init];
            settingVC.userImgAttachUrl = _userImgAttachUrl;
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }else if (indexPath.row == 1) {//登录密码
            ForgetPSViewController *chagePSVC =[[ForgetPSViewController alloc]init];
            [self.navigationController pushViewController:chagePSVC animated:YES];
            
        }else if (indexPath.row == 2) {//支付设置
            
            PayPassWordSettingViewController * payVC =[[ PayPassWordSettingViewController alloc]init];
            [self.navigationController pushViewController:payVC animated:NO];
            
        }

    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {
            
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
    else{
        
    }
    

}
///清除缓存
-(void)clearingCache
{
    [SDCycleScrollView  clearImagesCache];//清除缓存
    [self clearAllUserDefaultsData];
}

//移除所有本地数据
- (void)clearAllUserDefaultsData
{
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"key"];

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
//            [self clearingCache];//清除所有缓存;
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
        
        [self isIfNotSignIn];
        
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


#pragma mark - 注销
///登出
-(void)loginOutAction
{
 
    [[[NIMSDK sharedSDK]loginManager] logout:^(NSError * _Nullable error) {
        
        NSLog(@" 我已经退出了 ---- %@ = error",error);
    }];
}
@end
