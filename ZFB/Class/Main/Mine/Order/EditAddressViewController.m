//
//  EditAddressViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressPickerView.h"
#import "AddressLocationMapViewController.h"

@interface EditAddressViewController ()<UITextFieldDelegate>

///城市
@property (copy, nonatomic) NSString * cityStr;
@property (copy, nonatomic) NSString * longitudeSTR;//接收回传的经纬度
@property (copy, nonatomic) NSString * latitudeSTR;
@property (copy, nonatomic) NSString * postAddress;//收货地址（拼接补全的）
@property (copy, nonatomic) NSString * possid;//邮编

@property (weak, nonatomic ) IBOutlet UIButton    * locationButton;
@property (weak, nonatomic ) IBOutlet UITextField * tf_name;
@property (weak, nonatomic ) IBOutlet UITextField * tf_cellphone;
@property (weak, nonatomic ) IBOutlet UITextField * tf_detailAddress;
@property (weak, nonatomic ) IBOutlet UISwitch    * isDefaultSwitch;
@property (weak, nonatomic) IBOutlet UIButton *SaveAndbackAction;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"新增收货地址";
    self.SaveAndbackAction.clipsToBounds = YES;
    self.SaveAndbackAction.layer.cornerRadius = 4;
    
    self.tf_name.delegate          = self;
    self.tf_cellphone.delegate     = self;
    self.tf_detailAddress.delegate = self;
    
    [self.tf_name addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_cellphone addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_detailAddress addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self initSwitchView];
    
    if ( _postAddressId != nil || ![_postAddressId isEqualToString:@""]) {
        
        [self editUserRewardInfoMessagePostRequst];
    }
    
    self.locationButton.clipsToBounds = YES;
    self.locationButton.layer.cornerRadius = 4;
    
}

-(void)initSwitchView
{
    UISwitch * switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0,0, 40, 30)];
    self.isDefaultSwitch  = switchView;
    //拿到当前userdefults的状态
    self.isDefaultSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"switchType"];
    
    if (self.isDefaultSwitch.isOn) {
        NSLog(@"打开状态");
        _defaultFlag = @"1";
        
    }else{
        _defaultFlag = @"2";
        
        NSLog(@"关闭状态");
    }
    [self.isDefaultSwitch addTarget:self action:@selector(didClickSwitch:) forControlEvents:UIControlEventValueChanged];
    
}
///点击开关
-(void)didClickSwitch:(id)sender
{
    //拿到当前NSUserDefaults 的状态
    BOOL isOn =[[ NSUserDefaults standardUserDefaults]boolForKey:@"switchType"];
    //取反
    isOn = !isOn;
    
    //把当前的状态存进NSUserDefaults
    [[NSUserDefaults standardUserDefaults]setBool:isOn forKey:@"switchType"];
    
    self.isDefaultSwitch.on = isOn;
}


//选择城市
- (IBAction)didClickCityList:(id)sender {
    
    AddressLocationMapViewController * locaVC = [AddressLocationMapViewController new];
    locaVC.block = ^(NSString * address) {
        //        NSLog(@"-----%@------",address);
        [self.locationButton setTitle:address forState:UIControlStateNormal];
    };
    locaVC.longitudeBlock = ^(NSString * longitude) {
        _longitudeSTR = longitude;
    };
    locaVC.latitudeBlock = ^(NSString * latitude) {
        _latitudeSTR = latitude;
    };
    locaVC.possidBlock = ^(NSString * possid) {
        _possid = possid;
    };
    
    NSLog(@"%@ ------ %@------%@",_longitudeSTR,_latitudeSTR ,_possid)
    [self.navigationController pushViewController:locaVC animated:NO];
    
}

#pragma mark  - UITextFieldDelegate
- (void)textChange :(UITextField *)textfiled
{
    if (textfiled == _tf_name ) {
        
        NSLog(@"tf_name ==== %@",_tf_name.text);
    }
    else if (textfiled == _tf_cellphone  )
    {
        NSLog(@"_tf_cellphone ==== %@",_tf_name.text);
    }
    else
    {
        NSLog(@"_tf_detailAddress = = ===== %@",_tf_detailAddress.text);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tf_cellphone) {
        
        if ([_tf_cellphone.text isMobileNumber]) {
            NSLog(@"手机号 ===== %@",_tf_cellphone.text);
            
        }else{
            
            [self.view makeToast:@"手机格式不对哦~😯" duration:2 position:@"center"];
            
        }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_name resignFirstResponder];
    [_tf_detailAddress resignFirstResponder];
    [_tf_cellphone resignFirstResponder];
    
    [self.view endEditing:YES];
}


//设置保存事件
- (IBAction)saveActionAndBack:(id)sender {
    
    NSLog(@"saved！@@！！@！！！");
    if (_tf_name.text.length > 0 && ![_tf_cellphone.text isEqualToString:@""] && ![_tf_detailAddress.text isEqualToString:@""] ) {
        
        [self savedInfoMessagePostRequst];
    }
    else{
        [self.view makeToast:@"请填写完地址信息后再保存~" duration:2 position:@"center"];
        
    }
    
}
#pragma mark -   保存用户信息saveUserAddressInfo
-(void)savedInfoMessagePostRequst
{
    
    NSLog(@"_saveBool  ---------- %@",_defaultFlag);
    NSDictionary * param = @{
                             
                             
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"contactUserName":_tf_name.text,
                             @"contactMobilePhone":_tf_cellphone.text,
                             @"mobilePhone":@"",
                             @"deliveryProvince": _cityStr,
                             @"deliveryAddress":_tf_detailAddress.text,
                             @"defaultFlag":_defaultFlag,//是否为默认	否	1.是 2.否
                             @"postAddress":_postAddressId,// 用户全收货地址	否
                             @"zipCode":@"123123",// 邮政编号
                             @"longitude":_longitudeSTR,// 经度	否	6位小数
                             @"latitude":_latitudeSTR,// 纬度	否	6位小数
                             
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/saveUserAddressInfo"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}

#pragma mark - 编辑用户信息editUserReward
-(void)editUserRewardInfoMessagePostRequst
{
    
    NSLog(@"_postAddressId  ---------- %@",_postAddressId);
    NSDictionary * param = @{

                             @"postAddressId":_postAddressId,
                             
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/editUserReward"] params:param success:^(id response) {
        
        
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
        if ([response[@"resultCode"] intValue] == 0) {
            {
                _tf_name.text          = response[@"cmUserRewardInfo"][@"userName"];
                _tf_cellphone.text     = response[@"cmUserRewardInfo"][@"contactMobilePhone"];
                _cityStr               = response[@"cmUserRewardInfo"][@"postAddress"];
                _tf_detailAddress.text = response[@"cmUserRewardInfo"][@"replenish"];
                _defaultFlag           = response[@"cmUserRewardInfo"][@"defaultFlag"];
                
                
            }
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
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
