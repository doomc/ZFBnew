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
@interface iwantSendedViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _phoneNum;
    NSString * _verCodeNum;
    NSString * _emailNum;
    
    NSString * _imgbackUrl;
    NSString * _imgfaceUrl;
    BOOL _faceSuccess;
    BOOL _backSuccess;
}

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
    
    
    [self initView];
}
-(void)initView{
    //手机号
    self.tf_phoneNum.layer.masksToBounds = YES;
    self.tf_phoneNum.layer.cornerRadius = 4;
    self.tf_phoneNum.layer.borderWidth = 1;
    self.tf_phoneNum.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_phoneNum.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_phoneNum.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_phoneNum addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //验证码
    self.verCode_btn.layer.masksToBounds = YES;
    self.verCode_btn.layer.cornerRadius = 4;
    self.tf_VerCode.layer.masksToBounds = YES;
    self.tf_VerCode.layer.cornerRadius = 4;
    self.tf_VerCode.layer.borderWidth = 1;
    self.tf_VerCode.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_VerCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_VerCode.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_VerCode addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
   
    //电子邮箱
    self.tf_email.layer.masksToBounds = YES;
    self.tf_email.layer.cornerRadius = 4;
    self.tf_email.layer.borderWidth = 1;
    self.tf_email.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_email.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_email addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    if (self.tf_email == textField) {
        _emailNum = textField.text;
        NSLog(@"email：%@",textField.text);
    }
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
                            
                            _imgfaceUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
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

                            _imgbackUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                            _backSuccess = YES;
                        }
                    }];
                }
                    break;
            }
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
