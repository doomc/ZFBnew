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
    
    [self.tf_name addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.tf_cellphone addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.tf_mobilePhone addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.tf_detailAddress addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventTouchUpInside];
    
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
        
        NSLog(@"tf_name = = ===== %@",_tf_name.text);
    }
    else if (textfiled == _tf_cellphone  )
    {
        
        NSLog(@"_tf_cellphone = = ===== %@",_tf_cellphone.text);
        
    }
    else if (textfiled == _tf_mobilePhone   )
    {
        
        NSLog(@"_tf_mobilePhone = = ===== %@",_tf_mobilePhone.text);
        
    }
    else if ( textfiled == _tf_detailAddress )
    {
        
        NSLog(@"_tf_detailAddress = = ===== %@",_tf_detailAddress.text);
        
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
