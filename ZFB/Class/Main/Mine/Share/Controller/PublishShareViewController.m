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

//yykit
#import "YYTextView.h"
@interface PublishShareViewController ()<HXPhotoViewDelegate,UITextFieldDelegate,YYTextViewDelegate>

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray *imgUrl_mutArray;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) YYTextView * yytextView;

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
    [self settingBtnBoarder];

    [self settingPhotoView];
    
    [self settingYYTextView];
}
-(void)settingPhotoView
{
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(15, 10, KScreenW - 30, 0);
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor clearColor];
    [self.photoView  addSubview:photoView];
}
-(void)settingBtnBoarder
{
    self.tf_title.delegate = self;
    self.commitBtn.layer.cornerRadius = 4;
    self.commitBtn.clipsToBounds = YES;
    
}
-(void)settingYYTextView
{
    _yytextView = [[YYTextView alloc]initWithFrame:self.yytextView.frame];
    _yytextView.userInteractionEnabled = YES;
    _yytextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _yytextView.delegate = self;
     
}
#pragma mark - YYTextViewDelegate 文本编辑器
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    return  YES;
}
-(void)textViewDidChange:(YYTextView *)textView
{
    NSLog(@"%@ === text", textView.text);
}
#pragma mark - HXPhotoViewDelegate 相册选择器
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
}


#pragma  mark  - 发布共享 
- (IBAction)commitAction:(id)sender {
    
    [self publicMessagePostRequset];
}


#pragma  mark  - 发布共享内容请求
-(void)publicMessagePostRequset{
    
    NSDictionary * parma = @{
                             @"title":self.tf_title.text,
                             @"describe":@"",
                             @"userId":BBUserDefault.cmUserId,
                             @"imgUrls":BBUserDefault.cmUserId,
                             @"goodsId":BBUserDefault.cmUserId,
                             @"userAccount":BBUserDefault.cmUserId,
                             @"userLogo":BBUserDefault.cmUserId,
                             @"userNickname":BBUserDefault.cmUserId,
 
                             };
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/toShareGoods/goodsShareIssue"] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"] ) {

            [self.view makeToast:@"发布成功" duration:2 position:@"center"];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
