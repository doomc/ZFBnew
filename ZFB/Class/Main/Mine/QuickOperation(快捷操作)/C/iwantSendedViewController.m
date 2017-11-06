//
//  iwantSendedViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "iwantSendedViewController.h"
#import "HXPhotoViewController.h"

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeFace,
    PickerTypeBack,
};
@interface iwantSendedViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate,UIScrollViewDelegate>
{
    NSString * _phoneNum;
    NSString * _verCodeNum;
    NSString * _name;
    NSString * _smsCode;
    
    NSString * _imgbackUrl;
    NSString * _imgfaceUrl;
    BOOL _faceSuccess;
    BOOL _backSuccess;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrolleView;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign ,nonatomic) PickerType pickType;

@end

@implementation iwantSendedViewController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
        _manager.isOriginal = YES;
        _manager.endIsOriginal = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeFullScreen;
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  = @"我要配送";
    _faceSuccess = NO;
    _backSuccess = NO;
    self.scrolleView.delegate = self;
    
    [self initView];
}
-(void)initView{
    //手机号
    self.tf_phoneNum.layer.masksToBounds = YES;
    self.tf_phoneNum.layer.cornerRadius = 4;
    self.tf_phoneNum.layer.borderWidth = 1;
    self.tf_phoneNum.delegate = self;
    self.tf_phoneNum.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_phoneNum.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_phoneNum.text = BBUserDefault.userPhoneNumber;
    self.tf_phoneNum.userInteractionEnabled = NO;
    self.tf_phoneNum.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_phoneNum addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //验证码
    self.verCode_btn.layer.masksToBounds = YES;
    self.verCode_btn.layer.cornerRadius = 4;
    self.tf_VerCode.layer.masksToBounds = YES;
    self.tf_VerCode.layer.cornerRadius = 4;
    self.tf_VerCode.layer.borderWidth = 1;
    self.tf_VerCode.delegate = self;
    self.tf_VerCode.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_VerCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_VerCode.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_VerCode addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
   
    //name
    self.tf_Name.layer.masksToBounds = YES;
    self.tf_Name.layer.cornerRadius = 4;
    self.tf_Name.layer.borderWidth = 1;
    self.tf_Name.delegate = self;
    self.tf_Name.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_Name.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_Name.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_Name addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.commit_btn.layer.masksToBounds = YES;
    self.commit_btn.layer.cornerRadius = 4;
    
    //身份证正反面
    UITapGestureRecognizer * tapFace = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFaceView:)];
    tapFace.delegate = self;
    self.uploadFaceImgView.userInteractionEnabled = YES;
    [self.uploadFaceImgView addGestureRecognizer:tapFace];
    
    UITapGestureRecognizer * tapBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    tapBack.delegate = self;
    self.uploadBackImgView.userInteractionEnabled = YES;
    [self.uploadBackImgView addGestureRecognizer:tapBack];
}


#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"编辑完了");
}

-(void)textfieldChange:(UITextField *)textField{
    if (self.tf_phoneNum == textField) {
        _phoneNum = textField.text;
        NSLog(@"手机号%@",textField.text);
        
    }
    if (self.tf_VerCode == textField) {
        _verCodeNum = textField.text;
        NSLog(@"验证码：%@",textField.text);
        
    }
    if (self.tf_Name == textField) {
        _name = textField.text;
        NSLog(@"name：%@",textField.text);
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tf_phoneNum resignFirstResponder];
    [self.tf_Name resignFirstResponder];
    [self.tf_VerCode resignFirstResponder];
}
#pragma mark -  UITapGestureRecognizer 身份证正反面
//正面
-(void)tapFaceView:(UITapGestureRecognizer *)ges
{
    _pickType = PickerTypeFace;//是正面
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    NSLog(@"face");
}
//反面
-(void)tapBackView:(UITapGestureRecognizer *)ges
{
    _pickType = PickerTypeBack;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    NSLog(@"back");

}

#pragma mark- 图片选择器的代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    
        __weak typeof(self) weakSelf = self;
        [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchOriginalImageTpe completion:^(NSArray<UIImage *> *images) {
            switch (_pickType) {
                case PickerTypeFace:
                {
                    weakSelf.uploadFaceImgView.image = images.firstObject;
                    [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                        NSLog(@"%@",names);
                        if (state == 1) {
                            
                            _imgfaceUrl =[NSString stringWithFormat:@"%@",  names[0]];
                            _faceSuccess = YES;
                        }
                    }];
                }
                    break;
                    case PickerTypeBack:
                {
                    weakSelf.uploadBackImgView.image = images.firstObject;
                    [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                        NSLog(@"%@",names);
                        if (state == 1) {

                            _imgbackUrl =[NSString stringWithFormat:@"%@", names[0]];
                            _backSuccess = YES;
                        }
                    }];
                }
                    break;
            }
    }];
}


- (IBAction)commitAction:(UIButton *)sender {
    if ( _smsCode.length > 0  &&  _name.length > 0  &&  _imgfaceUrl != nil &&  _imgbackUrl!= nil) {
        
        [self appShopRegisteredPost];

    }else{
        
        [self.view makeToast:@"上传资料不全" duration:2 position:@"center"];

    }
 
}
- (IBAction)getVerCodeAction:(UIButton *)sender {
 
        // 网络请求
        [self ValidateCodePostRequset];
        
        [dateTimeHelper verificationCode:^{
            //倒计时完毕
            sender.enabled = YES;
            [sender setTitle:@"重新发送" forState:UIControlStateNormal];
            
        } blockNo:^(id time) {
            sender.enabled = NO;
            [sender setTitle:time forState:UIControlStateNormal];
        }];
 
}


#pragma mark - 验证码网络请求 SmsLogo 1 注册为配送  2注册商户
-(void)ValidateCodePostRequset
{
    [SVProgressHUD show];
    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"mobilePhone":BBUserDefault.userPhoneNumber,
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/SendMessages",zfb_baseUrl] params:parma success:^(id response) {
        
        NSString * code  = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            
            _smsCode = response[@"smsCode" ];
            self.verCode_btn.enabled = YES;
        }
        [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}


#pragma mark  - 配送员appShopRegistered
-(void)appShopRegisteredPost
{
    NSDictionary * parma = @{
                             @"deliveryPhone":BBUserDefault.userPhoneNumber,
                             @"Vcode":_smsCode,
                             @"deliveryName":_name,//姓名
                             @"frontUrl":_imgfaceUrl,
                             @"reverseUrl":_imgbackUrl,
                             @"latitude":BBUserDefault.latitude,//纬度
                             @"longitude":BBUserDefault.longitude,
                             
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/deliveryman",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
           
            [self.navigationController popToRootViewControllerAnimated:YES];

            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            
        }else{
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        }
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
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
