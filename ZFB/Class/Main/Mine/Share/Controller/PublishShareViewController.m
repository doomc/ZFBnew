//
//  PublishShareViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//


#import "PublishShareViewController.h"
//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

@interface PublishShareViewController ()<HXPhotoViewDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray *imgUrl_mutArray;
@property (weak, nonatomic) IBOutlet UIView *photoView;



@end

@implementation PublishShareViewController
-(NSMutableArray *)imgUrl_mutArray
{
    if (!_imgUrl_mutArray) {
        _imgUrl_mutArray = [NSMutableArray array];
    }
    return _imgUrl_mutArray;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.openCamera = YES;
        _manager.cacheAlbum = YES;
        _manager.lookLivePhoto = YES;
        //        _manager.outerCamera = YES;
        _manager.open3DTouchPreview = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum = 5;
        _manager.videoMaxNum = 5;
        _manager.maxNum = 5;
        _manager.rowCount = 3;
        _manager.saveSystemAblum = NO;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"共享资源 共享梦想";
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(15, 10, KScreenW - 30, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor clearColor];
    [self.photoView  addSubview:photoView];
    
}


- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {

    //    !!!!  必须是全部类型的那个数组 就是 allList 这个数组  !!!!
    [HXPhotoTools getSelectedListResultModel:allList complete:^(NSArray<HXPhotoResultModel *> *alls, NSArray<HXPhotoResultModel *> *photos, NSArray<HXPhotoResultModel *> *videos) {

        if (self.imgUrl_mutArray.count > 0) {
            [self.imgUrl_mutArray  removeAllObjects];
        }
        for (HXPhotoResultModel * photo in photos) {
            
            NSURL *url         = photo.fullSizeImageURL;
            NSString * urlpath = url.path;
            NSSLog(@"\n%@",urlpath);
            [self.imgUrl_mutArray addObject:urlpath];
        }
        //将数据传出去
        NSLog(@"imgUrl_mutArray === %@",self.imgUrl_mutArray);
    }];
 
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    
    self.photoView.height = frame.size.height + 20;
//    self.photoView.frame = CGRectMake(0, 284, KScreenW, frame.size.height + 20);
  
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
