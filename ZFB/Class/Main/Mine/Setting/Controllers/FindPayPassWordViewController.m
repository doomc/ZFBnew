//
//  FindPayPassWordViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindPayPassWordViewController.h"
#import "HXPhotoViewController.h"

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeFace,
    PickerTypeBack,
    PickerTypeHand,
};
@interface FindPayPassWordViewController ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _faceImgUrl;
    NSString * _backImgUrl;
    NSString * _handImgUrl;
}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *ceritificationBtn;
@property (assign ,nonatomic) PickerType pickType;

@end

@implementation FindPayPassWordViewController
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
    self.title = @"找回密码申诉";
    _ceritificationBtn.layer.masksToBounds = YES;
    _ceritificationBtn.layer.cornerRadius = 4;
    
    //上传正面
    UITapGestureRecognizer * tapUploadZheng = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgzhengAction:)];
    tapUploadZheng.delegate = self;
    [self.uploadImgZheng addGestureRecognizer:tapUploadZheng];
    self.uploadImgZheng.userInteractionEnabled = YES;

    
    //上传反面
    UITapGestureRecognizer * tapUploadFan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgFanAction:)];
    tapUploadFan.delegate = self;
    [self.uploadImgFan addGestureRecognizer:tapUploadFan];
    self.uploadImgFan.userInteractionEnabled = YES;
    
    //手持
    UITapGestureRecognizer * tapUploadHand = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImHandFaceAction:)];
    tapUploadHand.delegate = self;
    [self.uploadImgHandFace addGestureRecognizer:tapUploadHand];
    self.uploadImgHandFace.userInteractionEnabled = YES;
    
    
}

//上传正面
-(void)uploadImgzhengAction:(UIGestureRecognizer *)ges
{
    _pickType  = PickerTypeFace;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}
//上传反面
-(void)uploadImgFanAction:(UIGestureRecognizer *)ges
{
    _pickType  = PickerTypeBack;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
}
//上传手持
-(void)uploadImHandFaceAction:(UIGestureRecognizer *)ges
{
    _pickType  = PickerTypeHand;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - 获取图片代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:1 completion:^(NSArray<UIImage *> *images) {
        switch (_pickType) {
            case PickerTypeFace:
                
                weakSelf.uploadImgZheng.image = images.firstObject;
                break;
            case PickerTypeBack:
                weakSelf.uploadImgFan.image = images.firstObject;

                break;
            case PickerTypeHand:
                weakSelf.uploadImgHandFace.image = images.firstObject;

                break;
            default:
                break;
        }
       
        [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            if (state == 1) {
                
                switch (_pickType) {
                    case PickerTypeFace:
                        
                        _faceImgUrl = [NSString stringWithFormat:@"%@%@",aliOSS_baseUrl,names[0]];
                        break;
                    case PickerTypeBack:
             
                        _backImgUrl = [NSString stringWithFormat:@"%@%@",aliOSS_baseUrl,names[0]];
                        
                        break;
                    case PickerTypeHand:
                        
                        _handImgUrl = [NSString stringWithFormat:@"%@%@",aliOSS_baseUrl,names[0]];
                        
                        break;
                    default:
                        break;
                }
    
                NSLog(@"上传到阿里云成功了！");
            }
        }];
        
    }];
}

#pragma mark - 提交
- (IBAction)commitAction:(id)sender {
    if (_faceImgUrl == nil || [_faceImgUrl isEqualToString:@""]||_backImgUrl == nil || [_backImgUrl isEqualToString:@""] ||_handImgUrl == nil || [_handImgUrl isEqualToString:@""]) {
        
        [self.view makeToast:@"请上传正反面身份证照片" duration:2 position:@"center"];
        
    }else{
    
        [self updateImgPostRequst];
    }
}

-(void)backAction
{
    [self poptoUIViewControllerNibName:@"PayPassWordSettingViewController" AndObjectIndex:2];
}

//实名认证找回密码
-(void)updateImgPostRequst
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"file_face_url":_faceImgUrl,
                             @"file_back_url":_backImgUrl,
                             @"hand_url":_handImgUrl
                             };
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/appealPaymentCode"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0" ]) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交认证成功,我们将立刻进行审核，请耐心等待"];


        }else{
            [SVProgressHUD showErrorWithStatus:response[@"resultMsg"]];

        }
 
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
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
