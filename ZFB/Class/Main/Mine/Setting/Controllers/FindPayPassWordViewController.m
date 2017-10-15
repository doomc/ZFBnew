//
//  FindPayPassWordViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FindPayPassWordViewController.h"
#import "HXPhotoViewController.h"

@interface FindPayPassWordViewController ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _faceImgUrl;
    NSString * _backImgUrl;
    BOOL _isFace;
}
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation FindPayPassWordViewController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回密码申诉";
    
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
}

//上传正面
-(void)uploadImgzhengAction:(UIGestureRecognizer *)ges
{
    _isFace = YES;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}
//上传反面
-(void)uploadImgFanAction:(UIGestureRecognizer *)ges
{
    _isFace = NO;
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
}
#pragma mark - 获取图片代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:0 completion:^(NSArray<UIImage *> *images) {
        if (_isFace == YES) {
            weakSelf.uploadImgZheng.image = images.firstObject;

        }else{
            weakSelf.uploadImgFan.image = images.firstObject;

        }
        [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            if (state == 1) {
                if (_isFace == YES) {
                    _faceImgUrl = names[0];

                }else{
                    _backImgUrl = names[0];

                }
                NSLog(@"上传到阿里云成功了！");
            }
        }];
        
    }];
}

#pragma mark - 提交
- (IBAction)commitAction:(id)sender {

    [self updateImgPostRequst];
    
}

-(void)backAction
{
    [self poptoUIViewControllerNibName:@"PayPassWordSettingViewController" AndObjectIndex:1];
}


-(void)updateImgPostRequst
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"file_face_url":_faceImgUrl,
                             @"file_back_url":_backImgUrl,
                             
                             };
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/appealPaymentCode"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0" ]) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];

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
