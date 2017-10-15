//
//  CertificationViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  实名认证

#import "CertificationViewController.h"
#import "HXPhotoViewController.h"
@interface CertificationViewController ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _imgbackUrl;
    NSString * _imgfaceUrl;
    BOOL isFaceImg;
}

@property (weak, nonatomic) IBOutlet UIButton *ceritificationBtn;
 
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *uploadFaceView;

@property (weak, nonatomic) IBOutlet UIImageView *uploadBackView;

@end

@implementation CertificationViewController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
        _manager.cameraType = HXPhotoManagerCameraTypeHalfScreen;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
   
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
    isFaceImg = YES;//是正面
    NSLog(@"上传正面");
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    

}
//上传反面
-(void)uploadImgFanAction
{
    isFaceImg = NO;
    NSLog(@"上传反面");
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    
}
#pragma mark - 获取图片代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:0 completion:^(NSArray<UIImage *> *images) {
        NSLog(@"images === %@",images);
        if (isFaceImg == YES) {
            weakSelf.uploadFaceView.image = images.firstObject;

        }else{
            weakSelf.uploadBackView.image = images.firstObject;
        }
        [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            if (state == 1) {
                NSLog(@"上传到阿里云成功了！");
                if (isFaceImg == YES) {
                    _imgfaceUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];

                }else{
                 
                    _imgbackUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                }
            }
        }];
        
    }];
}


//实名认证
- (IBAction)CertificationAction:(id)sender {
    
    //需要处理是不是获取到图片地址了在请求
    [self certificationPostRequstet];
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
            
            [SVProgressHUD showSuccessWithStatus:@"提交认证成功,我们将立刻进行审核，请耐心等待"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"resultMsg"]];
            
        }
        
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}



/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
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
