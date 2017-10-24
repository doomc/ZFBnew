//
//  PayPassWordSettingViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PayPassWordSettingViewController.h"

#import "SettingPayPasswordViewController.h"//设置支付密码
#import "ChangePasswordViewController.h"//修改密码
#import "FindPayPassWordViewController.h"//密码申诉
#import "CertificationViewController.h"//实名认证

@interface PayPassWordSettingViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSString * _realNameFlag;//是否实名认证 1 是 2 否
    NSString * _isSetPassword;//是否设置了支付密码 1 设置过了 0 没有设置
    NSString * _state;
}
@property (nonatomic , strong) UITableView  * tableView;

@end

@implementation PayPassWordSettingViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,KScreenW , KScreenH -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"支付设置";
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [ self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
 
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = HEXCOLOR(0x363636);

    
    if ([BBUserDefault.isSetPassword isEqualToString:@"1"]) {//是否修改过密码
        if (indexPath.row == 0) {
            cell.textLabel.text =  @"修改支付密码";
        }else{
            if ( [_state isEqualToString:@"2"]) {//申诉认证通过了
                NSLog(@"已经实名认证了");
                cell.textLabel.text =  @"重新设置支付密码";
                
            }else{
                cell.textLabel.text =  @"找回支付密码";
            }
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text =  @"设置支付密码";
        }else{
            if ( [_state isEqualToString:@"2"]) {//申诉认证通过了
                NSLog(@"已经实名认证了");
                cell.textLabel.text =  @"重新设置支付密码";
                
            }else{
                cell.textLabel.text =  @"找回支付密码";
            }
        }
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {//设置密码/修改密码
        if ([_isSetPassword isEqualToString:@"1"]) {//设置过密码
            //去修改密码
            ChangePasswordViewController * changeVC = [ChangePasswordViewController new];
            [self.navigationController pushViewController:changeVC animated:NO];
            
        }else{
            //还没有设置密码 然后去实名认证
            if ( [_realNameFlag isEqualToString:@"1"]) {

                //实名认证过了 就去设置密码
                SettingPayPasswordViewController * settingVC = [SettingPayPasswordViewController  new];
                [self.navigationController pushViewController:settingVC animated:NO];

            }
            else{
                //进行实名认证、
                CertificationViewController * cerVC = [CertificationViewController new];
                [self.navigationController pushViewController:cerVC animated:NO];
                
            }

        }
    }else{ //申诉密码、重新设置支付密码
        if ( [_realNameFlag isEqualToString:@"1"]) {//实名认证过了
            NSLog(@"已经实名认证了");
            
            if ([_state isEqualToString:@""] || _state == nil) {//审核状态 1 审核中 2 审核通过 3审核拒绝
                NSLog(@"没有申诉过");
                FindPayPassWordViewController * findVC = [FindPayPassWordViewController new];
                [self.navigationController pushViewController:findVC animated:NO];
                
            }else{
                NSLog(@"申诉过了");
                if ([_state isEqualToString: @"1"]) {
                    
                    JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"申诉密码状态:审核中,请耐心等待" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertvc addAction:sure];
                    [alertvc addAction:cancle];
                    [self presentViewController:alertvc animated:YES completion:^{
                        
                    }];
                    
                }
                if ([_state isEqualToString: @"2"]) {
                    JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"申诉密码状态:审核通过" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SettingPayPasswordViewController * vc = [SettingPayPasswordViewController new];
                        [self.navigationController pushViewController:vc animated:NO];
                        
                    }];
                    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertvc addAction:sure];
                    [alertvc addAction:cancle];
                    [self presentViewController:alertvc animated:YES completion:^{
                        
                    }];
                }
                if ([_state isEqualToString: @"3"]) {
                    
                    JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"申诉密码状态:审核拒绝" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        FindPayPassWordViewController * findVC = [FindPayPassWordViewController new];
                        [self.navigationController pushViewController:findVC animated:NO];
                        
                    }];
                    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertvc addAction:sure];
                    [alertvc addAction:cancle];
                    [self presentViewController:alertvc animated:YES completion:^{
                        
                    }];
                }
            }
        }else{ //没有实名认证
            //进行实名认证、
            CertificationViewController * cerVC = [CertificationViewController new];
            [self.navigationController pushViewController:cerVC animated:NO];
            
        }
    }
 
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self minePagePOSTRequste];
    [self isAvailableCheckInfoPost];
}
- (void)isAvailableCheckInfoPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"cmUserId":BBUserDefault.cmUserId
                             };

    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getCheckInfo",zfb_baseUrl] params:param success:^(id response) {
 
        if ([response[@"data"] isEqualToString:@""]) {
              // 没有审核信息
            NSLog(@"没有审核信息");
            _state = nil;

        }else{
            _state = [NSString stringWithFormat:@"%@",response[@"data"][@"state"]];//审核状态 1 审核中 2 审核通过 3审核拒绝

        }
        [self.tableView reloadData];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark  - 网络请求 getUserInfo
-(void)minePagePOSTRequste
{
 
    NSDictionary * parma = @{
                             @"cmUserId":BBUserDefault.cmUserId,
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/getUserInfo"] params:parma success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response [@"resultCode"]];
        
        if ([code isEqualToString:@"0"]) {
            //是否实名认证 1 是 2 否
            _realNameFlag = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"realNameFlag"]];
            _isSetPassword = [NSString stringWithFormat:@"%@",response[@"userInfo"][@"isSetPassword"]];
            [self.tableView reloadData];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
          
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络出差了~" duration:2 position:@"center"];
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
