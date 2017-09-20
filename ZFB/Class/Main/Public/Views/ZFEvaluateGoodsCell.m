//
//  ZFEvaluateGoodsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEvaluateGoodsCell.h"
#import "UITextView+ZWLimitCounter.h"
//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"
 
@interface ZFEvaluateGoodsCell ()<UITextViewDelegate,HXPhotoViewDelegate>

//图片选择器
@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXPhotoView *photoView;


@end
@implementation ZFEvaluateGoodsCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initPickerView];
    [self initTextView];
    [self initCustomStarView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImg.clipsToBounds = YES;
    self.headImg.layer.cornerRadius =  35;
    
}

-(void)initCustomStarView
{
    //初始化五星好评控件
    self.starView.needIntValue = NO;//是否整数显示，默认整数显示
    self.starView.canTouch     = NO;//是否可以点击，默认为NO
    //        CGFloat number           = [storeList.starLevel floatValue];
    //        goodsCell.starView.scoreNum     = [NSNumber numberWithFloat:number ];//星星显示个数
    self.starView.normalColorChain(RGBA(244, 244, 244, 1));
    self.starView.highlightColorChian(HEXCOLOR(0xfe6d6a));

}

-(void)initTextView
{
    //textview
    self.textView.zw_limitCount = 150;//个数显示
    self.textView.zw_labHeight = 20;//高度
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入评价,150字以内哦~";
    
    // 添加输入改变Block回调.
    [self.textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
 
//        NSLog(@"----%@-----",textView.text);
    
        if ([self.delegate respondsToSelector:@selector(getTextViewValues:)]) {
            [self.delegate getTextViewValues:textView.text];
        }
    }];
    
    // 添加到达最大限制Block回调.
    [self.textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
    // 达到最大限制数后的相应操作.
    }];
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
    return YES;
    NSLog(@"结束编辑");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"结束编辑 ------%@",textView.text);
    
}

#pragma mark - initPickerView
-(void)initPickerView
{
    self.photoView                 = [HXPhotoView photoManager:self.manager];
    self.photoView.frame           = CGRectMake(0, 0, KScreenW - 30 , (KScreenW - 30-3*5)/4);
    self.photoView.delegate        = self;
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:self.photoView];
    
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

        //将数据传出去
        if ([self.delegate respondsToSelector:@selector(uploadImageArray:)]) {
            
            [self.delegate uploadImageArray: images ];
        }
        NSLog(@"images === %@",images);
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
////            NSSLog(@"\n%@",urlpath);
//            [self.imgUrl_mutArray addObject:urlpath];
//        }
//        //将数据传出去
//        if ([self.delegate respondsToSelector:@selector(uploadImageArray:)]) {
//            
//            [self.delegate uploadImageArray: self.imgUrl_mutArray ];
//        }
//        NSLog(@"imgUrl_mutArray === %@",self.imgUrl_mutArray);
//    }];
    
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
//    NSSLog(@"%@",NSStringFromCGRect(frame));
//    NSLog(@"  我当前的高度是 ---%f" ,frame.size.height) ;
    
    self.heightOfConstraint.constant = frame.size.height;
    self.pickerView.frame  = CGRectMake(0, 0, KScreenW - 30 , self.heightOfConstraint.constant + 10);
    if ([self.delegate respondsToSelector:@selector(reloadCellHeight:)]) {
      
        [self.delegate reloadCellHeight:self.heightOfConstraint.constant + 10];
    }
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
