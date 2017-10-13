//
//  CertificationCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  实名认证cell

#import "CertificationCell.h"
#import "HXPhotoViewController.h"
@interface CertificationCell ()<UIGestureRecognizerDelegate,HXPhotoViewControllerDelegate>
{
    NSString * _faceUrl;
}
@property (strong, nonatomic) HXPhotoManager *manager;

@end
@implementation CertificationCell
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //上传正面
    UITapGestureRecognizer * tapUploadface = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgfaceAction:)];
    tapUploadface.delegate = self;
    [self.uploadImg addGestureRecognizer:tapUploadface];
    self.uploadImg.userInteractionEnabled = YES;
 
    
}

-(void)uploadImgfaceAction:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(didClickUploadFace:)]) {
        [self.delegate  didClickUploadFace:_faceUrl];
    }
}

#pragma mark - 获取图片代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:0 completion:^(NSArray<UIImage *> *images) {
        
        
        weakSelf.uploadImg.image = images.firstObject;
        
        [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
            NSLog(@"%@",names);
            if (state == 1) {
                NSLog(@"上传到阿里云成功了！");
                
                _faceUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                
            }
        }];
        
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
