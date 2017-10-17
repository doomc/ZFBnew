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
    PickerTypeHand,
};

@interface CertificationViewController ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _imgbackUrl;
    NSString * _imgfaceUrl;
    NSString * _imghandUrl;
 
}
@property (strong, nonatomic) HXPhotoManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *ceritificationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *uploadFaceView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadBackView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadHandView;
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
        _manager.cameraType = HXPhotoManagerCameraTypeHalfScreen;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
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
    
    UITapGestureRecognizer * tapHand =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgHandAction)];
    tapHand.delegate = self;
    self.uploadHandView.userInteractionEnabled = YES;
    [self.uploadHandView addGestureRecognizer:tapHand];
    
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
//上传手持
-(void)uploadImgHandAction
{
    _pickType = PickerTypeHand;
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
                weakSelf.uploadFaceView.image = images.firstObject;
 
                break;
            case PickerTypeBack:
                weakSelf.uploadBackView.image = images.firstObject;

                break;
            case PickerTypeHand:
                
                weakSelf.uploadHandView.image = images.firstObject;
                break;
            default:
                break;
        }
 
        [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            if (state == 1) {
                NSLog(@"上传到阿里云成功了！");
                switch (_pickType) {
                    case PickerTypeFace:
                         _imgfaceUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        break;
                    case PickerTypeBack:
                        
                        _imgbackUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        break;
                    case PickerTypeHand:
                        _imghandUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        break;
                    default:
                        break;
                }
               
            }
        }];
        
    }];
}


//实名认证
- (IBAction)CertificationAction:(id)sender {

    if (_imgbackUrl == nil || [_imgbackUrl isEqualToString:@""]||_imgfaceUrl == nil || [_imgfaceUrl isEqualToString:@""]) {
       
        [self.view makeToast:@"请上传正反面身份证照片" duration:2 position:@"center"];
        
    }else{
   
        //需要处理是不是获取到图片地址了在请求
        [self certificationPostRequstet];
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
                             @"hand_url":_imghandUrl

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
