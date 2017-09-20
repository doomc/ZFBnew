//
//  FeedPickerTableViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedPickerTableViewCell.h"

//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

@interface FeedPickerTableViewCell ()<HXPhotoViewDelegate>

//图片选择器
@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXPhotoView *photoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfConstraint;

@end

@implementation FeedPickerTableViewCell
 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self initPickerView];
}
-(void)initPickerView
{
    self.photoView                 = [HXPhotoView photoManager:self.manager];
    self.photoView.frame           = CGRectMake(0, 0, KScreenW - 30 , (KScreenW - 30-3*5)/4);
    self.photoView.delegate        = self;
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.pickerCollectionView addSubview:self.photoView];
    
}

- (void)dealloc {
    
    [self.manager clearSelectedList];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray <HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    //    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
    //    将HXPhotoModel模型数组转化成HXPhotoResultModel模型数组  - 已按选择顺序排序
    //    !!!!  必须是全部类型的那个数组 就是 allList 这个数组  !!!!
    
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);
        if ([self.delegate respondsToSelector:@selector(uploadImageArray:)]) {
            [self.delegate uploadImageArray:images];
        }
    }];
    
//    [HXPhotoTools getSelectedListResultModel:allList complete:^(NSArray<HXPhotoResultModel *> *alls, NSArray<HXPhotoResultModel *> *photos, NSArray<HXPhotoResultModel *> *videos) {
//        //        NSSLog(@"\n全部类型:%@\n照片:%@\n视频:%@",alls,photos,videos);
//        if (self.imgUrl_mutArray.count > 0) {
//            [self.imgUrl_mutArray  removeAllObjects];
//        }
//        for (HXPhotoResultModel * photo in photos) {
//            
//            NSURL *url         = photo.fullSizeImageURL;
//            NSString * urlpath = url.path;
//            NSSLog(@"\n%@",urlpath);
//            [self.imgUrl_mutArray addObject:urlpath];
//        }
//        //将数据传出去
//        [self.delegate uploadImageArray: self.imgUrl_mutArray ];
//        NSLog(@"imgUrl_mutArray === %@",self.imgUrl_mutArray);
//    }];
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    NSLog(@"  我当前的高度是 ---%f" ,frame.size.height) ;
    
    self.heightOfConstraint.constant = frame.size.height;
    self.pickerCollectionView.frame  = CGRectMake(0, 0, KScreenW - 30 , self.heightOfConstraint.constant + 10);
    [self.delegate reloadCellHeight:self.heightOfConstraint.constant + 10];
 
}

//图片管理器
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager                    = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera         = YES;
        _manager.cacheAlbum         = YES;
        _manager.lookLivePhoto      = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType         = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum        = 5;
        _manager.videoMaxNum        = 5;
        _manager.maxNum             = 8;
        _manager.saveSystemAblum    = NO;
    }
    return _manager;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
