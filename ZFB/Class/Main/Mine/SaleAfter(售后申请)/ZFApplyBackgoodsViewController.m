//
//  ZFApplyBackgoodsViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFApplyBackgoodsViewController.h"
//vc
#import "ZFBackWaysViewController.h"//确认退回的信息VC
//view
#import "SalesAfterPopView.h"//弹框选择退货原因
#import "PlaceholderTextView.h"
//图片选择器
#import "HXPhotoViewController.h"
#import "HXPhotoView.h"

@interface ZFApplyBackgoodsViewController ()<SalesAfterPopViewDelegate,UIScrollViewDelegate,HXPhotoViewDelegate>
{
    BOOL  _isCommited;
    NSString * _imgUrlAppending;//拼接的图片地址

}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView  *img_view;//商品图片
@property (weak, nonatomic) IBOutlet UILabel      *lb_title;//商品名字
@property (weak, nonatomic) IBOutlet UILabel      *lb_goosPrice;//价格
@property (weak, nonatomic) IBOutlet UILabel      *lb_goodsCount;//商品数量

@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturn;//退货
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsReturnMoney;//返回原退款

@property (weak, nonatomic) IBOutlet UILabel  *lb_chooseResult;//请选择结果
@property (weak, nonatomic) IBOutlet UIView   * textBgView;//描述
@property (weak, nonatomic) IBOutlet UIButton *didClickNextPage;//下一页

@property (strong , nonatomic) SalesAfterPopView   *selectReasonView;//选择原因
@property (strong , nonatomic) UIView              *popBackGView;//背景图
@property (strong , nonatomic) PlaceholderTextView *textView;
//图片选择器
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView    *photoView;
//添加图片
@property (weak, nonatomic) IBOutlet UIView             *AddPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHight;

@property (nonatomic, strong) NSArray * imgUrl_mutArray;//存放选取的图片数组

@end

@implementation ZFApplyBackgoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isCommited = NO;
    [self initGoodsData];
    [self InitPlaceholderTextView];
    [self initPickerView];
}
-(void)initPickerView
{
    self.photoView                 = [HXPhotoView photoManager:self.manager];
    self.photoView.frame           = CGRectMake(10, 0, KScreenW - 20 , (KScreenW - 30-3*5)/4);
    self.photoView.delegate        = self;
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.AddPickerView addSubview:self.photoView];
    
}

- (void)dealloc {
    
    [self.manager clearSelectedList];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray <HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
        NSSLog(@"%@",images);
        _imgUrl_mutArray = images;
    }];
 
}
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
    NSLog(@"  我当前的高度是 ---%f" ,frame.size.height) ;
    
    self.contraintHight.constant    = frame.size.height;
    self.AddPickerView.frame        = CGRectMake(10, 0, KScreenW - 20 , self.contraintHight.constant + 10);
    self.mainScrollView.contentSize = CGSizeMake(KScreenW, 700 + self.contraintHight.constant +10);
    
    
}
//图片管理器
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager                    = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera         = YES;
        _manager.cacheAlbum         = YES;
        _manager.cameraType         = HXPhotoManagerCameraTypeSystem;
        _manager.photoMaxNum        = 5;
        _manager.maxNum             = 5;
        _manager.saveSystemAblum    = NO;
    }
    return _manager;
}

-(SalesAfterPopView *)selectReasonView
{
    if (!_selectReasonView) {
        _selectReasonView          = [[SalesAfterPopView alloc]initWithFrame:CGRectMake(20, 0, KScreenW - 40, 44 * 6 +40)];
        _selectReasonView.center   = self.view.center;
        _selectReasonView.delegate = self;
    }
    return  _selectReasonView;
}

-(UIView *)popBackGView
{
    if (!_popBackGView) {
        _popBackGView                 = [[UIView alloc]initWithFrame:self.view.bounds];
        _popBackGView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_popBackGView addSubview:self.selectReasonView];
    }
    return _popBackGView;
}

-(void)InitPlaceholderTextView
{
    _textView                       = [[PlaceholderTextView alloc]init];
    _textView.frame                 = self.textBgView.frame;
    _textView.placeholderLabel.font = [UIFont systemFontOfSize:14];
    _textView.placeholder           = @"请输入文字...";
    _textView.maxLength             = 100;
    _textView.font                  = [UIFont systemFontOfSize:14];
    [self.textBgView  addSubview:_textView];
    
    [_textView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
        _problemDescr = textView.text;
    }];
    
    
}
//初始化商品数据
-(void)initGoodsData
{
    self.title                   = @"申请退货";
    self.mainScrollView.delegate = self;
    
    self.lb_title.text      = _goodsName;
    self.lb_goosPrice.text  = [NSString stringWithFormat:@"价格 :%@元",_price];
    self.lb_goodsCount.text = [NSString stringWithFormat:@"数量 x%@",_goodCount];
    [self.img_view sd_setImageWithURL:[NSURL URLWithString:_img_urlStr] placeholderImage:[UIImage imageNamed:@""]];
    
    self.didClickNextPage.clipsToBounds      = YES;
    self.didClickNextPage.layer.cornerRadius = 4;
    
    self.lb_goodsReturnMoney.clipsToBounds      = YES;
    self.lb_goodsReturnMoney.layer.cornerRadius = 2;
    self.lb_goodsReturnMoney.layer.borderWidth  = 1;
    self.lb_goodsReturnMoney.layer.borderColor  = HEXCOLOR(0xf95a70).CGColor;
    
    self.lb_goodsReturn.clipsToBounds      = YES;
    self.lb_goodsReturn.layer.cornerRadius = 2;
    self.lb_goodsReturn.layer.borderWidth  = 1;
    self.lb_goodsReturn.layer.borderColor  = HEXCOLOR(0xf95a70).CGColor;
}

/**
 下一步
 @param sender 提交申请
 */
- (IBAction)didClickNextPage:(id)sender {
//    ZFBackWaysViewController *bcVC =[[ ZFBackWaysViewController alloc]init];
//    [self.navigationController pushViewController: bcVC animated:YES];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(didChangeStatus:) object:sender];
    [self performSelector:@selector(didChangeStatus:) withObject:sender afterDelay:2];
    
}
-(void)didChangeStatus:(UIButton *)sender
{
    NSLog(@"不叨叨 ------------");
    if (_isCommited == YES) {
        [self.view makeToast:@"请勿重复提交" duration:2 position:@"center"];
        [SVProgressHUD dismiss];

        return;
    }else{
        if (_reason.length > 0 && _problemDescr.length > 0 ) {
            if (_imgUrl_mutArray.count > 0) {
                [OSSImageUploader asyncUploadImages:_imgUrl_mutArray complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    if (state == 1) {
                        _imgUrlAppending =  [names componentsJoinedByString:@","];
                        NSSLog(@"names = %@",_imgUrlAppending);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self uploadSuccessPushVC];
                        });
                    }else{
                        NSSLog(@"上传失败");
                    }
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadSuccessPushVC];
                });
            }
          
        }else{
            JXTAlertController * alert = [JXTAlertController alertControllerWithTitle:@"提示" message:@"申请原因或问题描述没填写" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sure       = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sure];
            [self.navigationController presentViewController:alert animated:NO completion:^{
                
            }];
            [SVProgressHUD dismiss];
            _isCommited = NO;
        }
 
    }
}

-(void)uploadSuccessPushVC
{
    _isCommited = YES;

    //图片为空的状态
    ZFBackWaysViewController *bcVC =[[ ZFBackWaysViewController alloc]init];
    if (_imgUrl_mutArray.count > 0) {
        bcVC.imgArr          = _imgUrlAppending ;//图片字符串
    }else{
        bcVC.imgArr          = @"";
    }
    bcVC.goodsName  = _goodsName;
    bcVC.price      = _price ;
    bcVC.goodCount  = _goodCount;
    bcVC.coverImgUrl = _coverImgUrl;
    
    ///需要发送到售后申请的数据
    bcVC.orderId     = _orderId;
    bcVC.orderNum    = _orderNum;
    bcVC.goodsId     = _goodsId;
    bcVC.serviceType = @"0";///服务类型    否     0 退货 1 换货
    bcVC.storeId     = _storeId;
    bcVC.orderTime   = _orderTime;
    bcVC.storeName   = _storeName;
    bcVC.postName    = _postName;
    bcVC.postPhone   = _postPhone;
    bcVC.orderGoodsId= _orderGoodsId;
    bcVC.skuId = _skuId;

    //原因
    bcVC.reason          = _reason;
    bcVC.problemDescr    = _problemDescr;
    
    [self.navigationController pushViewController: bcVC animated:YES];
    [SVProgressHUD dismiss];
    _isCommited = NO;

}
/**
 申请原因
 @param sender 选择列表
 */
- (IBAction)didClickChooseReason:(id)sender {
    
    [self.view addSubview:self.popBackGView];
    
}
#pragma mark -  SalesAfterPopViewDelegate 选择原因
//移除popView
-(void)deletePopView
{
    [self.popBackGView removeFromSuperview];
}
-(void)getReasonString:(NSString *)reason{
    
    NSLog(@"%@",reason);
    _reason = self.lb_chooseResult.text = reason;
    [self.popBackGView removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"取消隐藏");
    [self.view endEditing:YES];
    [self.popBackGView removeFromSuperview];
     
}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD  dismiss];
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
