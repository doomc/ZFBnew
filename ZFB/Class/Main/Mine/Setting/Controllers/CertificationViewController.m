//
//  CertificationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  实名认证

#import "CertificationViewController.h"
#import "HXPhotoViewController.h"

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeFace,
    PickerTypeBack,
};

@interface CertificationViewController ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _imgbackUrl;
    NSString * _imgfaceUrl;
    BOOL _faceSuccess;
    BOOL _backSuccess;
}
@property (strong, nonatomic) HXPhotoManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *ceritificationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *uploadFaceView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadBackView;
@property (assign ,nonatomic) PickerType pickType;

@end

@implementation CertificationViewController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
        _manager.isOriginal = YES;
        _manager.endIsOriginal = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    _faceSuccess = NO;
    _backSuccess = NO;
    
    _ceritificationBtn.layer.masksToBounds = YES;
    _ceritificationBtn.layer.cornerRadius = 4;
    
    UITapGestureRecognizer * tapFace =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgzhengAction)];
    tapFace.delegate = self;
    self.uploadFaceView.userInteractionEnabled = YES;
    [self.uploadFaceView addGestureRecognizer:tapFace];
    
    UITapGestureRecognizer * tapBack =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgFanAction)];
    tapBack.delegate = self;
    self.uploadBackView.userInteractionEnabled = YES;
    [self.uploadBackView addGestureRecognizer:tapBack];
    

    
}
//上传正面
-(void)uploadImgzhengAction
{
    _pickType = PickerTypeFace;//是正面
    NSLog(@"上传正面");
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    

}
//上传反面
-(void)uploadImgFanAction
{
    _pickType = PickerTypeBack;
    NSLog(@"上传反面");
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
}

#pragma mark - 获取图片代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:1 completion:^(NSArray<UIImage *> *images) {
        NSLog(@"images === %@",images);
        switch (_pickType) {
            case PickerTypeFace:
            {
                weakSelf.uploadFaceView.image = images.firstObject;
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
                weakSelf.uploadBackView.image = images.firstObject;
                [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"%@",names);
                    if (state == 1) {
                        _imgbackUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        _backSuccess = YES;
                    }
                }];
            }
                break;
            default:
                break;
        }
    }];
}


//实名认证
- (IBAction)CertificationAction:(id)sender {

    if (_backSuccess == YES && _faceSuccess == YES) {
        
        //需要处理是不是获取到图片地址了在请求
        [self certificationPostRequstet];
    }else{

        if (_imgbackUrl == nil  || _imgfaceUrl == nil) {
            
            [self.view makeToast:@"网络较慢，请稍等片刻" duration:2 position:@"center"];
            
        }else{
            [self.view makeToast:@"图片正在上传，请耐心等待" duration:2 position:@"center"];
        }
    }
}
//认证请求
-(void)certificationPostRequstet
{
    NSDictionary * param = @{
                             
                             @"account":BBUserDefault.userPhoneNumber,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"file_face_url":_imgfaceUrl,
                             @"file_back_url":_imgbackUrl,

                             };
    [SVProgressHUD showWithStatus:@"正在提交认证..."];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/realNameApprove"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0" ]) {
            
            [SVProgressHUD showSuccessWithStatus:@"认证成功!"];
            
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
