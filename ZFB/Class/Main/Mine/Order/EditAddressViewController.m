//
//  EditAddressViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressPickerView.h"

@interface EditAddressViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) AddressPickerView *myAddressPickerView;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_cellphone;
@property (weak, nonatomic) IBOutlet UITextField *tf_mobilePhone;
@property (weak, nonatomic) IBOutlet UITextField *tf_detailAddress;
@property (weak, nonatomic) IBOutlet UISwitch *isDefaultSwitch;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"编辑收货地址";
 
    self.tf_name.delegate =self;
    self.tf_cellphone.delegate =self;
    self.tf_mobilePhone.delegate =self;
    self.tf_detailAddress.delegate =self;
    
    [self.tf_name addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_cellphone addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_mobilePhone addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tf_detailAddress addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

    [self initSwitchView];
    
    if ( _postAddressId != nil || ![_postAddressId isEqualToString:@""]) {
     
        [self editUserRewardInfoMessagePostRequst];
    }
}

-(void)initSwitchView
{
    UISwitch * switchView= [[UISwitch alloc]initWithFrame:CGRectMake(0,0, 40, 30)];
    self.isDefaultSwitch = switchView;
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
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"保存";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font=SYSTEMFONT(14);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);
    
    return right_button;
}


//选择城市
- (IBAction)didClickCityList:(id)sender {
    
    _myAddressPickerView = [AddressPickerView shareInstance];
    
    [_myAddressPickerView showAddressPickView];
    
    [self.view addSubview:_myAddressPickerView];
    
    weakSelf(weakself);
    _myAddressPickerView.block = ^(NSString *province,NSString *city,NSString *district)
    {
        weakself.lb_city.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,district];
    };
    
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
    else if (textfiled == _tf_mobilePhone   )
    {
        NSLog(@"_tf_mobilePhone = = ===== %@",_tf_mobilePhone.text);
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
    
   else if (textField == _tf_mobilePhone) {
        
        if ([_tf_mobilePhone.text isMobileNumber]) {
            NSLog(@"备用手机号 ===== %@",_tf_cellphone.text);
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
    [_tf_mobilePhone resignFirstResponder];
    [_tf_cellphone resignFirstResponder];
    
    [self.view endEditing:YES];
}


//设置保存事件
-(void)right_button_event:(UIButton*)sender{
    
    NSLog(@"saved！@@！！@！！！");
    
    if (_tf_name.text.length > 0 && ![_tf_cellphone.text isEqualToString:@""] && ![_tf_detailAddress.text isEqualToString:@""] && ![_lb_city.text isEqualToString:@""]) {
        
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
     NSDictionary * parma = @{
                             
                             @"svcName":@"saveUserAddressInfo",
//                             @"cmUserId":BBUserDefault.cmUserId,
                             @"contactUserName":_tf_name.text,
                             @"contactMobilePhone":_tf_cellphone.text,
                             @"mobilePhone":_tf_mobilePhone.text ,
                             @"deliveryProvince": _lb_city.text,
                             @"deliveryAddress":_tf_detailAddress.text,
                             @"defaultFlag":_defaultFlag,
                             
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [SVProgressHUD show];
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        NSLog(@"dic= = == =%@",responseObject);
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];

        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];
    

}


#pragma mark - 编辑用户信息editUserReward
-(void)editUserRewardInfoMessagePostRequst
{
    
    NSLog(@"_postAddressId  ---------- %@",_postAddressId);
    NSDictionary * parma = @{
                             
                             @"svcName":@"editUserReward",
                             @"postAddressId":_postAddressId,
 
                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [SVProgressHUD show];
    [PPNetworkHelper POST:zfb_url parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
            NSDictionary * jsondic = [NSString dictionaryWithJsonString:dataStr];
           
            _tf_name.text  = jsondic[@"cmUserRewardInfo"][@"contactUserName"];
            _tf_cellphone.text  = jsondic[@"cmUserRewardInfo"][@"contactMobilePhone"];
            _tf_mobilePhone.text  = jsondic[@"cmUserRewardInfo"][@"mobilePhone"];
            _lb_city.text  = jsondic[@"cmUserRewardInfo"][@"deliveryProvince"];
            _tf_detailAddress.text  = jsondic[@"cmUserRewardInfo"][@"deliveryAddress"];
            _defaultFlag = jsondic[@"cmUserRewardInfo"][@"defaultFlag"];
//            NSLog(@"jsondic= = == =%@",jsondic);
            [SVProgressHUD dismiss];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
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
