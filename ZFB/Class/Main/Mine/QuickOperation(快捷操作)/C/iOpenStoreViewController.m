//
//  iOpenStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "iOpenStoreViewController.h"
#import "HXPhotoViewController.h"
#import "AddressLocationMapViewController.h"
//model
#import "CollectionCategoryModel.h"
#import "ClassLeftListModel.h"

#import "CommonClassTypeView.h"

typedef NS_ENUM(NSUInteger, PickerType) {
    PickerTypeLicese = 0,//营业执照
    PickerTypeIDCard,//身份证
    PickerTypeOpenLicese,//开户许可
    PickerTypeLetterCommitment,//商品承诺书
};
@interface iOpenStoreViewController ()
<
    UITextFieldDelegate,
    UIGestureRecognizerDelegate,
    HXPhotoViewControllerDelegate,
    CommonClassTypeViewDelegate
>
{
    NSString * _storeAddress;//门店地址
    NSString * _storeName;
    NSString * _contactName;
    NSString * _contactPhone;
    BOOL  _isThemeType;// yes 一级列表  NO 二级列表
    NSString * _currentTypeID;//当前一级列表的Id
    NSString * _themeTitle;//当前一级列表的Id
    NSString * _themeTitle2;//当前一级列表的Id
    //上传的图片
    NSString * _liceseImgUrl;
    NSString * _idCardImgUrl;
    NSString * _openLiceseImgUrl;
    NSString * _commitmentImgUrl;
    
    NSString * _longitude;
    NSString * _latitude;

}
@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign ,nonatomic) PickerType pickType;
@property (strong, nonatomic) NSMutableArray * themeArray; //2级列表
@property (strong, nonatomic) NSMutableArray * classTypeArray;//1级列表

//自定义弹框
@property (strong, nonatomic) CommonClassTypeView * typeView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UIView * coverView;


@end

@implementation iOpenStoreViewController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.openCamera = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
        _manager.isOriginal = YES;
        _manager.endIsOriginal = YES;
        _manager.cameraType = HXPhotoManagerCameraTypeFullScreen;
    }
    return _manager;
}
-(NSMutableArray *)classTypeArray{
    if (!_classTypeArray) {
        _classTypeArray = [NSMutableArray array];
    }
    return _classTypeArray;
}
-(NSMutableArray *)themeArray{
    if (!_themeArray) {
        _themeArray = [NSMutableArray array];
    }
    return _themeArray;
}
-(CommonClassTypeView *)typeView
{
    if (!_typeView) {
        _typeView = [[CommonClassTypeView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 250 )];
        _typeView.delegate = self;
        _typeView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _typeView.isThemeType = _isThemeType;
    }
    return _typeView;
}
-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, KScreenW, KScreenH )];
        _coverView.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_coverView addSubview:self.typeView];
    }
    return _coverView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title  = @"我要开店";

    [self initView];
}
-(void)initView{
    //手机号
    self.tf_storeName.layer.masksToBounds = YES;
    self.tf_storeName.layer.cornerRadius = 4;
    self.tf_storeName.layer.borderWidth = 1;
    self.tf_storeName.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_storeName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_storeName.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_storeName addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //联系人
    self.tf_contactName.layer.masksToBounds = YES;
    self.tf_contactName.layer.cornerRadius = 4;
    self.tf_contactName.layer.masksToBounds = YES;
    self.tf_contactName.layer.cornerRadius = 4;
    self.tf_contactName.layer.borderWidth = 1;
    self.tf_contactName.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_contactName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_contactName.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_contactName addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //联系号码
    self.tf_phoneNum.layer.masksToBounds = YES;
    self.tf_phoneNum.layer.cornerRadius = 4;
    self.tf_phoneNum.layer.borderWidth = 1;
    self.tf_phoneNum.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_phoneNum.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_phoneNum.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_phoneNum addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //主题类型
    self.themeType_btn.layer.masksToBounds = YES;
    self.themeType_btn.layer.cornerRadius = 4;
    self.themeType_btn.layer.borderWidth = 1;
    self.themeType_btn.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    
    self.themeMan_btn.layer.masksToBounds = YES;
    self.themeMan_btn.layer.cornerRadius = 4;
    self.themeMan_btn.layer.borderWidth = 1;
    self.themeMan_btn.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    //提交审核
    self.commmit_btn.layer.masksToBounds = YES;
    self.commmit_btn.layer.cornerRadius = 4;
    
    
    //营业执照
    UITapGestureRecognizer * tapLisece = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLiseceView:)];
    tapLisece.delegate = self;
    self.licenseView.userInteractionEnabled = YES;
    [self.licenseView addGestureRecognizer:tapLisece];
    
    //身份证正反面
    UITapGestureRecognizer * tapIdCard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIdCardView:)];
    tapIdCard.delegate = self;
    self.IDCardView.userInteractionEnabled = YES;
    [self.IDCardView addGestureRecognizer:tapIdCard];
    
    //开户许可
    UITapGestureRecognizer * tapOpen = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOpenView:)];
    tapOpen.delegate = self;
    self.openLicenceView.userInteractionEnabled = YES;
    [self.openLicenceView addGestureRecognizer:tapOpen];
    
    //商品承诺书
    UITapGestureRecognizer * tapCommitMent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCommitMentView:)];
    tapCommitMent.delegate = self;
    self.letterOfCommitmentView.userInteractionEnabled = YES;
    [self.letterOfCommitmentView addGestureRecognizer:tapCommitMent];
}
#pragma mark - 添加的手势
//营业执照
-(void)tapLiseceView:(UITapGestureRecognizer *)ges
{
    _pickType =PickerTypeLicese;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}
//身份证
-(void)tapIdCardView:(UITapGestureRecognizer *)ges
{
    _pickType =PickerTypeIDCard;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];

}
//开户许可
-(void)tapOpenView:(UITapGestureRecognizer *)ges
{
    _pickType =PickerTypeOpenLicese;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];

}
//商品承诺书
-(void)tapCommitMentView:(UITapGestureRecognizer *)ges
{
    _pickType =PickerTypeLetterCommitment;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"编辑完了");
}
-(void)textfieldChange:(UITextField *)textField{
    if (self.tf_storeName == textField) {
        _storeName = textField.text;
        NSLog(@"店铺：%@",textField.text);
        
    }
    if (self.tf_contactName == textField) {
        _contactName = textField.text;
        NSLog(@"联系人：%@",textField.text);
        
    }
    if (self.tf_phoneNum == textField) {
        _contactPhone = textField.text;
        NSLog(@"电话：%@",textField.text);
    }
}


#pragma mark- 图片选择器的代理
- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original {
    
    __weak typeof(self) weakSelf = self;
    [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchOriginalImageTpe completion:^(NSArray<UIImage *> *images) {
        switch (_pickType) {
            case PickerTypeLicese:
            {
                weakSelf.licenseView.image = images.firstObject;
                [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"%@",names);
                    if (state == 1) {
                        
                        _liceseImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
//                        _faceSuccess = YES;
                    }
                }];
            }
                break;
            case PickerTypeIDCard:
            {
                weakSelf.IDCardView.image = images.firstObject;
                [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"%@",names);
                    if (state == 1) {
                        
                        _idCardImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
//                        _backSuccess = YES;
                    }
                }];
            }
                break;
            case PickerTypeOpenLicese:
            {
                weakSelf.openLicenceView.image = images.firstObject;
                [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"%@",names);
                    if (state == 1) {
                        _openLiceseImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        //                        _backSuccess = YES;
                    }
                }];
            }
                break;
                
            case PickerTypeLetterCommitment:
            {
                weakSelf.letterOfCommitmentView.image = images.firstObject;
                [OSSImageUploader asyncUploadImage:images[0] complete:^(NSArray<NSString *> *names, UploadImageState state) {
                    NSLog(@"%@",names);
                    if (state == 1) {
                        _commitmentImgUrl = [NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
                        //                        _backSuccess = YES;
                    }
                }];
            }
                break;
        }
        
    }];
}


#pragma mark - 主题类型 1级2级列表
//1级列表
- (IBAction)themeTypeOneClass:(id)sender {
    _isThemeType = YES;
    self.themeArray = nil;

    [self.themeType_btn setBackgroundColor:HEXCOLOR(0xf7f7f7)] ;
    [self.themeMan_btn setBackgroundColor:HEXCOLOR(0xffffff)] ;

    [self classListTableVieWithGoodTypePostRequset];

}

//2级列表
- (IBAction)themeTypeTwoClass:(id)sender {
    self.classTypeArray = nil;
 
    _isThemeType = NO;

    [self.themeMan_btn setBackgroundColor:HEXCOLOR(0xf7f7f7)] ;
    [self.themeType_btn setBackgroundColor:HEXCOLOR(0xffffff) ] ;

    [self secondClassListWithGoodTypePostRequsetTypeid:_currentTypeID];

}

#pragma mark - CommonClassTypeViewDelegate  获取到当前typeId
-(void)didClicktypeId:(NSString *)typeId AndTitle:(NSString *)title
{
     if (_isThemeType == YES) {
         _currentTypeID = typeId;
         _themeTitle = title;
     }else{
         _themeTitle2 = title;
     }

}
//关闭视图
-(void)removeFromtoSuperView
{
    [self.coverView removeFromSuperview];
 }
//确定之后的操作
-(void)selectedAfter
{
    if (_isThemeType == YES) {
        [self.themeType_btn setTitle:_themeTitle forState:UIControlStateNormal];
        [self removeFromtoSuperView];

    }else{
        
        [self.themeMan_btn setTitle:_themeTitle2 forState:UIControlStateNormal];
        [self removeFromtoSuperView];

    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.scrollView endEditing:YES];
    [self removeFromtoSuperView];
}

#pragma mark - 补充店铺地址
- (IBAction)addressAction:(id)sender {
    
    AddressLocationMapViewController * locaVC = [AddressLocationMapViewController new];
    locaVC.searchReturnBlock = ^(NSString *name, CGFloat longitude, CGFloat latitude, NSString *postCode) {
        
        NSLog(@"name=%@, longitude=%f, latitude=%f, postCode=%@", name, longitude, latitude, postCode);
        [self.address_btn setTitle:name forState:UIControlStateNormal];
        _longitude =[NSString stringWithFormat:@"%.6f",longitude];
        _latitude = [NSString stringWithFormat:@"%.6f",latitude];
    };
    [self.navigationController pushViewController:locaVC animated:NO];
}

#pragma mark - 提交审核
- (IBAction)commitAction:(id)sender {
    
    [self appShopRegisteredPost];
}


#pragma mark  - 第一级分类网络请求
-(void)classListTableVieWithGoodTypePostRequset{
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getMaxType",zfb_baseUrl] params:nil success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.classTypeArray.count > 0) {
                [self.classTypeArray removeAllObjects];
            }
            ClassLeftListModel * list = [ClassLeftListModel mj_objectWithKeyValues:response];
            for (CmgoodsClasstypelist * Typelist in list.data.CmGoodsTypeList) {
                [self.classTypeArray addObject:Typelist];
            }
            NSLog(@"classTypeArray:%@",self.classTypeArray);
            
            self.typeView.classListArray = self.classTypeArray;

            [_scrollView addSubview:self.coverView];
            [self.coverView bringSubviewToFront:self.bgView];
            [self.typeView reloadCollctionView];

        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark  - 第2级分类网络请求
-(void)secondClassListWithGoodTypePostRequsetTypeid:(NSString *) typeID
{
    NSDictionary * parma = @{
                             @"typeId":typeID,
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getNextType",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            if (self.themeArray.count > 0) {
                [self.themeArray removeAllObjects];
            }
            CollectionCategoryModel *model = [CollectionCategoryModel mj_objectWithKeyValues:response];
            for (Nexttypelist  * list in model.data.nextTypeList) {
                [self.themeArray addObject:list];
            }
         
            NSLog(@"themeArray:%@",self.themeArray);
       
            [_scrollView addSubview:self.coverView];
            [self.coverView bringSubviewToFront:self.bgView];
            
            self.typeView.brandListArray = self.themeArray;
            [self.typeView reloadCollctionView];

         }

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}

#pragma mark  - 成为商户appShopRegistered
-(void)appShopRegisteredPost
{
    NSDictionary * parma = @{
                             @"mobilePhone":_phoneNum,
                             @"email":_email,
                             @"serviceType":_themeTitle,//一级类型
                             @"bussinessType":_themeTitle2,//二级类型
                             @"businessLicense":_liceseImgUrl,//营业执照
                             @"icFaceAttachId":_idCardImgUrl,//身份证正面照
                             @"bankLicense":_openLiceseImgUrl,//开户行许可证
                             @"servicePeomiseUrl":_commitmentImgUrl,//商品承诺书
                             @"storeContact":_contactName,//联系人
                             @"contactPhone":_contactPhone,//联系人电话
                             @"storeName":_storeName,//店铺名称
                             @"storeAddress":_storeAddress,//商户地址
                             @"areaId":@"2220",//区域id
                             @"latitude":_latitude,//经度
                             @"longitude":_longitude,//纬度
       
                             };
    [SVProgressHUD showWithStatus:@"由于上传图片过多,上传较慢,请耐心等待"];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/appShopRegistered",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:response[@"resultMsg"]];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"resultMsg"]];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        NSLog(@"error=====%@",error);
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
