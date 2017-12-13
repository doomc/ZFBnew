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
#import "UserProtocolViewController.h"

//model
#import "CollectionCategoryModel.h"
#import "ClassLeftListModel.h"

#import "CommonClassTypeView.h"
#import "ProvinceVC.h"
#import "IQKeyboardManager.h"

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
    CommonClassTypeViewDelegate,
    UIScrollViewDelegate
>
{
    NSString * _storeAddress;//门店地址
    NSString * _storeName;
    NSString * _contactName;
//    NSString * _contactPhone;
    BOOL  _isThemeType;// yes 一级列表  NO 二级列表
    NSString * _onceTypeID;//当前一级列表的Id
    NSString * _secondTypeID;//当前2级列表的Id

    NSString * _themeTitle;//当前一级列表的Id
    NSString * _themeTitle2;//当前一级列表的Id
    //上传的图片
    NSString * _liceseImgUrl;
    NSString * _idCardImgUrl;
    NSString * _openLiceseImgUrl;
    NSString * _commitmentImgUrl;
    
    NSString * _longitude;
    NSString * _latitude;
    
    NSString * _areaId;
    NSString * _address;//详细地址
    
    BOOL _isSureFirst;//是否点击了确定   yes 点击了 NO，没点击
    BOOL _isSureSecond;//是否点击了确定   yes 点击了 NO，没点击
    BOOL _isSelectedBtn;//是否点击了确定   yes 点击了 NO，没点击
    BOOL _isAgree;//是否同意并阅读   yes 点击了 NO，没点击

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


-(void )creatCoverView
{
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, KScreenW, KScreenH )];
    _coverView.backgroundColor = RGBA(0, 0, 0, 0.2);
    [_scrollView addSubview:_coverView];

    _typeView = [[CommonClassTypeView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 250 )];
    _typeView.delegate = self;
    _typeView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [_coverView addSubview:_typeView];
    [self.coverView bringSubviewToFront:self.bgView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.delegate = self;
    self.title  = @"我要开店";
    _isSureFirst = NO;
    _isSureSecond = NO;
    _isSelectedBtn = NO;
    _isAgree = NO;

    [self initView];
}
-(void)initView{
    //手机号

    self.tf_storeName.delegate = self;
    [self.tf_storeName addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];

    //联系人
//    self.tf_contactName.layer.masksToBounds = YES;
//    self.tf_contactName.layer.cornerRadius = 4;
//    self.tf_contactName.layer.borderWidth = 1;
//    self.tf_contactName.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
//    self.tf_contactName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
//    self.tf_contactName.leftViewMode = UITextFieldViewModeAlways;
    self.tf_contactName.delegate = self;
    [self.tf_contactName addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //主题类型
    self.themeType_btn.layer.masksToBounds = YES;
    self.themeType_btn.layer.cornerRadius = 4;
    self.themeType_btn.layer.borderWidth = 1;
    self.themeType_btn.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    
    self.themeMan_btn.layer.masksToBounds = YES;
    self.themeMan_btn.layer.cornerRadius = 4;
    self.themeMan_btn.layer.borderWidth = 1;
    self.themeMan_btn.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
  
    //提交审核
    self.commmit_btn.layer.masksToBounds = YES;
    self.commmit_btn.layer.cornerRadius = 6;
    
    
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
    _pickType = PickerTypeOpenLicese;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];

}
//商品承诺书
-(void)tapCommitMentView:(UITapGestureRecognizer *)ges
{
    _pickType = PickerTypeLetterCommitment;
    
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"我开始编辑");
    if ( self.tf_storeName == textField  ) {
        [self.tf_storeName becomeFirstResponder];
        
    } else{
        [self.tf_contactName becomeFirstResponder];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"编辑完了");
}
-(void)textfieldChange:(UITextField *)textField{
    if ( self.tf_storeName == textField  ) {
        _storeName = textField.text;
        NSLog(@"店铺：%@",textField.text);
    }else{
        _contactName = textField.text;
        NSLog(@"联系人：%@",textField.text);
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tf_storeName resignFirstResponder];
    [self.tf_contactName resignFirstResponder];

    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [self.tf_storeName resignFirstResponder];
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
//                        _liceseImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];

                        _liceseImgUrl =[NSString stringWithFormat:@"%@", names[0]];
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
//                        _idCardImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];

                        _idCardImgUrl =[NSString stringWithFormat:@"%@", names[0]];
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
                        _openLiceseImgUrl =[NSString stringWithFormat:@"%@", names[0]];
//                        _openLiceseImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];
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
                        _commitmentImgUrl = [NSString stringWithFormat:@"%@", names[0]];
//                        _commitmentImgUrl =[NSString stringWithFormat:@"%@%@",aliOSS_baseUrl, names[0]];

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
- (IBAction)themeTypeOneClass:(UIButton *)sender {
 
    if (_isSelectedBtn == YES) {
        return;
    }else{

        [self removeFromtoSuperView];
        [self.themeType_btn setBackgroundColor:HEXCOLOR(0xf7f7f7)] ;//1级
        [self.themeMan_btn setBackgroundColor:HEXCOLOR(0xffffff)] ;
        [self classListTableVieWithGoodTypePostRequset];
        _isSelectedBtn = YES;

    }

 }

//2级列表
- (IBAction)themeTypeTwoClass:(id)sender {
  
    if (_isSelectedBtn == YES ) {
        if ( _isSureFirst == YES  && _onceTypeID.length > 0) {
            [self.themeMan_btn setBackgroundColor:HEXCOLOR(0xf7f7f7)] ;
            [self.themeType_btn setBackgroundColor:HEXCOLOR(0xffffff)] ;
            [self secondClassListWithGoodTypePostRequsetTypeid:_onceTypeID];
            _isSelectedBtn =   NO;
            _isSureFirst = NO  ;//重新赋值第一级
        }
        else{
            [self.view makeToast:@"请先选择主题分类" duration:2 position:@"center"];
        }
    } else{
        [self.view makeToast:@"请先选择主题分类" duration:2 position:@"center"];
        _isSelectedBtn = NO;
        _isSureFirst = NO  ;//重新赋值第一级

        return;
    }
   
}

#pragma mark - CommonClassTypeViewDelegate  获取到当前typeId
//获取1级列表的id
-(void)didClassOnetypeId:(NSString *) typeId AndTitle:(NSString * )title
{
    _onceTypeID = typeId;
    _themeTitle = title;
    NSLog(@"%@ - %@",typeId,title);

 
}
//获取二级列表id
-(void)didClassTwotypeId:(NSString *) typeId AndTitle:(NSString * )title
{
    _secondTypeID = typeId;
    _themeTitle2 = title;
    NSLog(@"%@- %@",typeId,title);
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
        _isSureFirst = YES;
        _isSelectedBtn = YES;

    }else{
        [self.themeMan_btn setTitle:_themeTitle2 forState:UIControlStateNormal];
        [self removeFromtoSuperView];
        _isSureSecond = YES;
        _isSelectedBtn = NO;

    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.coverView endEditing:YES];
    [self removeFromtoSuperView];
}

#pragma mark - 补充详细店铺地址
- (IBAction)addressAction:(id)sender {
    
    AddressLocationMapViewController * locaVC = [AddressLocationMapViewController new];
    locaVC.searchReturnBlock = ^(NSString *name, CGFloat longitude, CGFloat latitude, NSString *postCode) {
        
        NSLog(@"name=%@, longitude=%f, latitude=%f, postCode=%@", name, longitude, latitude, postCode);
        [self.detailAddressBtn setTitle:name forState:UIControlStateNormal];
        _storeAddress  = name;
        _longitude =[NSString stringWithFormat:@"%.6f",longitude];
        _latitude = [NSString stringWithFormat:@"%.6f",latitude];
    };
    [self.navigationController pushViewController:locaVC animated:NO];
}

//选择地址
- (IBAction)selectedAreaAddress:(id)sender {
    
    ProvinceVC * vc = [ ProvinceVC new];
    vc.addressBlock = ^(NSString *areaId, NSString *address) {
        NSLog(@"第一级：%@,%@",areaId,address);
        [self.address_btn setTitle:address forState:UIControlStateNormal];
        _areaId = areaId;
        _address = address;
    };
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - 提交审核
- (IBAction)commitAction:(id)sender {
 
    if (_storeName.length > 0 && _contactName.length > 0  && _areaId.length > 0 && _address.length > 0 && _commitmentImgUrl.length > 0 && _liceseImgUrl.length > 0 &&  _idCardImgUrl.length >0  && _openLiceseImgUrl.length > 0 && _commitmentImgUrl.length > 0  && _isAgree == YES) {
       
        [self appShopRegisteredPost];

    }else{
        [self.view makeToast:@"填写信息不完整" duration:2 position:@"center"];

    }
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
            [self creatCoverView];
  
            self.typeView.isThemeType = _isThemeType = YES;
            self.typeView.classListArray = self.classTypeArray;
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
       
            [self creatCoverView];
            self.typeView.isThemeType = _isThemeType = NO;
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
                             @"mobilePhone":BBUserDefault.userPhoneNumber,
                             @"email":@"",
                             @"serviceType":_onceTypeID,//一级类型
                             @"bussinessType":_secondTypeID,//二级类型
                             
                             @"businessLicense":_liceseImgUrl,//营业执照
                             @"icFaceAttachId":_idCardImgUrl,//身份证正面照
                             @"bankLicense":_openLiceseImgUrl,//开户行许可证
                             @"servicePeomiseUrl":_commitmentImgUrl,//商品承诺书

                             @"storeContact":_contactName,//联系人
                             @"contactPhone":BBUserDefault.userPhoneNumber,//联系人电话
                             @"storeName":_storeName,//店铺名称
                             @"storeAddress":_storeAddress,//商户地址
                             @"areaId":_areaId,//区域id
                             @"latitude":_latitude,//经度
                             @"longitude":_longitude,//纬度
       
                             };
    [SVProgressHUD showWithStatus:@"由于上传图片过多,上传较慢,请耐心等待"];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/appShopRegistered",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功，等待审核"];
 
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"延迟2.0秒后打印出来的日志！");
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:response[@"resultMsg"]];
        }
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        NSLog(@"error=====%@",error);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//同意
- (IBAction)selectbtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _isAgree = YES;
    }else{
        _isAgree = NO;

    }
}

//交易平台协议
- (IBAction)dealProtocol:(id)sender {
    UserProtocolViewController * userVC = [UserProtocolViewController new];
    userVC.navTitle = @"平台服务协议";
    userVC.mutContent =@"重要须知:\n   《展富宝网络交易平台服务协议》（以下简称“平台服务协议”）是由展富宝网站（即www.zavfb.com，以下简称“展富宝网站”）的运营方即重庆展付卫网络技术有限公司（以下简称“甲方”）与商家（以下简称“乙方”或“商家”）达成的关于提供和使用展富宝网络交易平台（以下简称“网络交易平台”）服务的各项条款、条件和规则。\n    本协议包括本协议正文及本协议附件（本协议附件包括但不限于《展富宝网站商家在线签约系统服务协议》、《承诺函》、《签约确认书》、《费用确认书》(前述文件的具体名称可能做适当调整)及所有甲方已经发布的或将来发布的各类规则，以下合称“附件”）。本协议附件为本协议不可分割的一部分，与本协议正文具有同等法律效力";
    [self.navigationController pushViewController:userVC animated:NO];
}
//商家在线签约服务协议
- (IBAction)onlineProtocol:(id)sender {
    UserProtocolViewController * userVC = [UserProtocolViewController new];
    userVC.navTitle = @"展富宝网站商家在线签约系统服务协议";
    userVC.mutContent =@"重要须知：\n《展富宝网站商家在线签约系统服务协议》（以下简称“本协议”）是由展富宝网站（即www.zavfb.com ，以下简称“展富宝网站”）的运营方即重庆展付卫网络技术有限公司（以下简称“甲方”）与商家（以下简称“乙方”或“商家”）达成的关于提供和使用展富宝网站商家在线签约系统（以下简称“在线签约系统”）服务的各项条款、条件和规则。\n  本协议包括本协议正文及本协议附件（本协议附件包括但不限于所有甲方已经发布的或将来发布的各类规则，以下简称“附件”）。本协议附件为本协议不可分割的一部分，与本协议正文具有同等法律效力。 在适用的法律法规允许的最大限度内，甲方有权根据情况不时地制定、修订、调整或变更本协议正文或附件，并将提前至少7日公示并通知乙方。前述制定、修订、调整或变更后的本协议正文或附件一经甲方公示并通知乙方后，立即自动生效，成为本协议的一部分；虽有前述约定，本协议生效后，如乙方不同意前述制定、修订、调整或变更后的本协议正文或附件，可自甲方公示并通知乙方之日起3个工作日内以通知方式向甲方提出异议，在此种情况下，本协议将于乙方通知之日起自动终止，且甲方对于该等终止不负有任何违约责任或其他责任，乙方应与甲方协商本协议终止事宜（包括但不限于款项结算事宜(如有) ）。如乙方未根据前述约定向甲方提出异议，即视为乙方接受前述制定、修订、调整、或变更后的本协议正文或附件；如乙方登录或继续使用展富宝网站相关账户（包括但不限于商家账户，下同），即视为乙方接受前述制定、修订、调整或变更后的本协议正文或附件。\n  本协议项下要求或允许给予的所有“公示”、“通知”、“公示并通知”、“同意”、“批准”、“许可”等应为书面形式，并应通过在展富宝网站公示、传真、电子邮件、专人派送、特快专递或挂号信等方式发出。任何一方均可通过前述方式发出通知来改变其以后所有接收通知的投递地址。除非另有相反的明确规定，通知若以在展富宝网站公示形式发出，则送达时间应以展富宝网站最早公示之时为准；若以传真形式发出，则送达时间应以传真传送记录所显示之时间为准；若以电子邮件形式发出，则送达时间应以邮件进入收件方指定之电子邮件系统之时为准；若以专人派送或特快专递形式发出，则送达时间应以收件方签收之时间为准；若以挂号信形式发出，则送达时间应以邮局之发送单据为凭，自发送之日起七日为准。\n  本协议之签署、效力、解释和执行以及本协议项下争议之解决均适用中华人民共和国法律（为本协议之目的，不包括香港、澳门、台湾法律）。甲乙双方在签署、履行本协议中发生的争议或纠纷，应通过友好协商解决；协商不成的，任何一方有权将争议提交至甲方住所地人民法院诉讼解决。\n  甲方在此特别提醒乙方认真阅读、充分理解本协议各条款，并请乙方审慎考虑并选择接受或不接受本协议。如果乙方一经选择“我已阅读、同意并接受”选项并点击“同意以上文件并继续”按钮（前述选项或按钮的具体表述可能会做适当调整），即表示其已接受本协议，并同意受本协议各项条款的约束。如果乙方不同意本协议中的任何条款，可以不予选择“我已阅读、同意并接受”选项或不予点击“同意以上文件并继续”按钮（前述选项或按钮的具体表述可能会做适当调整），在此种情况下，乙方未予接受本协议，本协议未生效，乙方将无法使用在线签约系统服务。\n  本“重要须知”为本协议正文的组成部分。\n  1. 在线签约系统使用说明\n  1.1 商家通过在线签约系统提出新签或续签申请，应按照甲方的流程要求进行相应环节手续之开展和完成，包括但不限于如实填写商家信息、提供商家资质文件、在线审阅并确认相关协议文本、缴纳相关费用（包括但不限于平台使用费、保证金、及其他必需费用(如有) ）后，经甲方审核通过后，商家正式入驻展富宝网站，甲方将为商家开通商家后台系统，商家可通过商家后台系统在展富宝网站上运营自己的店铺。\n  1.2 商家以及甲方通过在线签约系统做出的申请、资料提交以及审查等行为，仅为双方根据本协议通过在线签约系统表达合作意向、履行签约及沟通等手续的必备程序；在双方未最终签署《展富宝网络交易平台服务协议》（以下简称“平台协议”）之前，前述行为对于双方不产生法律上的约束力，即，商家做出的前述行为并不表示其已成功入驻展富宝网站，甲方做出的前述行为并不表示甲方已审批通过商家入驻展富宝网站。甲方在线审核同意商家提交之新签或续签申请，并将审核同意结果通知商家时，平台协议方始成立，对双方均产生法律上的约束力。双方间最终合作事宜及运营规则均以双方签署的平台协议约定为准。\n  1.3 商家通过在线签约系统提交的文件、资料、信息，将由甲方自行或委托第三方对商家入驻资质进行审查，商家需按照甲方或甲方委托的第三方的规定，提供相应的具体信息（包括但不限于银行账号、联系方式等），并支付相应必需费用（如有）。\n  2. 商家的权利和义务\n  2.1 商家应仔细阅读且充分理解展富宝网站公示并通知的签约商家标准，并确保其资质符合公示并通知的签约标准，商家知悉并理解甲方将结合自身业务发展情况对商家进行选择。\n  2.2 商家应按照甲方要求如实提供签约申请所需文件、资料及信息，商家应确保其提供的全部文件、资料及信息（包括但不限于其在展富宝网站上输入、上传的文件、资料、信息）合法、有效、真实、准确、完整，经甲方审核通过后，商家不得擅自修改、替换相应文件、资料及信息。如商家提供的文件、资料或信息不合法、无效或失效、不真实、不准确、或不完整的，由此产生的任何争议、纠纷、处罚、诉讼、仲裁、投诉、索赔等均由商家自行负责处理并承担全部法律责任（包括但不限于赔偿由此给顾客、甲方或任何他方造成的全部损失），并且甲方有权立即终止商家使用在线签约系统、相关账户的权利，或终止与商家的部分或全部合作（不论该等合作是否基于本协议而产生，下同）。如商家提供的文件、资料或信息不合法、无效或失效、不真实、不准确、或不完整的, 甲方有权要求商家提供文件、资料或信息资料原件以供审核，商家有义务积极配合调查。如商家提供的文件、资料或信息系伪造或虚构等，由此产生的甲方或甲方委托的他方支出的成本和费用（包括但不限于甄别、鉴定和调查的成本和费用）均由乙方承担。\n  2.3 商家保证其使用在线签约系统时提供的所有文件、资料及信息均符合适用的法律法规的规定和本协议的规定，不含有违法信息、木马等软件病毒或任何其他形式的垃圾信息；且商家应按本协议的规定使用在线签约系统，不得从事影响或可能影响在线签约系统正常运营的行为。否则，甲方有权立即删除前述文件、资料或信息，并有权立即终止商家使用在线签约系统、相关账户的权利，或终止与商家的部分或全部合作。\n  2.4 商家应注意及时登陆在线签约系统查询甲方公示并通知的签约申请结果。商家如经甲方审核通过，应按照甲方要求办理相关手续；如经甲方审核未通过，则商家可针对未审核通过的原因，根据甲方或甲方委托的第三方要求进行相应更正、补充、更替相应资料或信息，并由甲方再行审核是否通过。\n  2.5 商家应按照甲方的规定妥善保管、使用甲方提供的相关账户（包括但不限于用户名、原始密码信息或商家自行修改的密码），并确保使用其该等账户的主体均为商家或商家授权的人员；除非适用的法律法规另有明确规定或本协议另有明确约定，商家不得以任何形式泄露、擅自转让、披露或授权他人使用该等帐号。否则，由此产生的任何争议、纠纷、处罚、诉讼、仲裁、投诉、索赔等均由商家自行负责处理并承担全部法律责任（包括但不限于赔偿由此给顾客、甲方或任何他方造成的全部损失），并且甲方有权立即终止商家使用在线签约系统、该等账户的权利，或立即终止与商家的部分或全部合作。\n  2.6 商家因为违法经营受到执法机关调查的，如根据适用的法律法规规定，甲方有义务向执法机关披露商家的交易信息或商家提供的文件、资料、信息的，乙方认可甲方将向执法机关披露商家的交易信息或商家提供的文件、资料、信息，且不受双方之间达成的有关文件、资料或信息使用和保密协议、约定或条款的约束。\n  3. 展富宝网站的权利和义务\n  3.1 在线签约系统仅为商家申请入驻展富宝网站平台。商家正式入驻展富宝网站后，将在商家后台系统中运营其在展富宝网站上的网上店铺。\n  3.2 在适用的法律法规允许的最大限度内，甲方有权对商家提供的资料及信息进行审核，并有权根据适用的法律法规的规定和自身业务情况对商家进行选择；在适用的法律法规允许的最大限度内，甲方对商家提交资料及信息的审核均不代表甲方对审核内容的合法、有效、真实、准确、完整性作出确认，商家保证其提供的资料及信息的合法、有效、真实、准确、完整性并负责对此承担全部法律责任。\n  3.3 商家认可，无论其是否通过甲方的审核，甲方有权在适用的法律法规允许的最大限度内对商家提供的资料及信息予以留存并随时查阅、进行必要披露或使用，而无需返还商家。\n  3.4 除适用的法律法规另有明确规定或本协议另有明确约定外，甲方应在现有技术支持的基础上尽力确保并维护在线签约系统的正常运营。\n  4. 信息的使用和保密\n  4.1 除适用的法律法规另有明确规定、本协议另有明确约定、甲方和顾客之间的相关协议另有约定外，顾客数据库为甲方的资产。为本协议之目的，“顾客数据库”指可被甲方不时更新的，与运营展富宝网站或展富宝网站上任何交易有关而由甲方收集或汇总的顾客登陆、密码、个人数据、联系、促销、喜好、交易及其他信息的数据库，无论该等信息是由商家、顾客或任何其他合法授权人上载、产生、要求或收集的。乙方特此（1）向甲方转让和同意向甲方转让其在或对顾客数据库全部或部分可能有的（或将来获得的）任何和所有权利和利益（包括但不限于其中的任何知识产权）；并且（2）不可撤销地承诺不时及时采取为使该等转让生效可能必需的所有行动、获得为使该等转让生效可能必需的所有同意以及签署和报备为使该等转让生效可能必需的文件。顾客数据库或其任何部分不构成乙方的商业秘密。\n  4.2 乙方可能在展富宝网站上获得某些有关顾客、顾客订单和交易的数据。乙方仅可为（1）依法完成、记录相关顾客交易和就相关顾客交易进行记账之目的，或（2）履行本协议之目的而使用该等数据，且条件是该等使用应当符合适用的法律法规、展富宝网站发布的隐私声明、服务协议及其他数据安全保护规定、以及乙方作为一方或另行受之约束的协议、约定、规则或任何其他文件。仅受制于前述规定的前提下，未经甲方事先书面同意，乙方不应对甲方的任何数据（包括但不限于顾客数据库）进行使用、披露、转让，包括但不限于以复制、传播等方式使用在展富宝网站上展示的任何资料。\n  4.3 除适用的法律法规另有明确规定或本协议另有明确规定（包括但不限于本协议第4.2款的规定）外，甲方或乙方应对其在本协议签订、履行过程中所获知的对方各项信息，包括但不限于本协议内容、签约和履行主体、框架、条款和附件、财务信息、商业信息、商业模式等（以下合称“保密信息”）承担严格的保密义务，直至保密信息进入公知领域时止。\n  知识产权\n  5.1 展富宝网站上的图表、标识、网页页眉、按钮图标、文字、服务品名等标示在网站上的信息都是甲方及其关联方的财产，受中国和国际知识产权法的保护。未经甲方事先许可，商家或任何他方不得使用、复制或用作其他用途。\n  5.2 商家如侵犯甲方或任何他方知识产权的，由此产生的任何争议、纠纷、处罚、诉讼、仲裁、投诉、索赔等均由商家自行负责处理并承担全部法律责任（包括但不限于赔偿由此给顾客、甲方或任何他方造成的全部损失），并且甲方有权立即终止商家使用在线签约系统、相关账户的权利，或终止与商家的部分或全部合作。甲方调查商家侵权事件发生的全部成本和费用，商家认可甲方有权从双方之间的结算款项（包括但不限于货款、保证金）直接扣除。在甲方调查商家知识产权侵权事件过程中，商家有义务披露能够证明真实进货渠道和相关交易记录的原始财务记录和凭证，拒不配合或提供虚假、伪造文件、资料或信息的，甲方有权立即终止商家使用在线签约系统、相关账户的权利，终止与商家的部分或全部合作，或要求商家承担赔偿责任。\n  6. 违约责任\n  6.1 商家违反适用的法律规定或本协议约定给甲方造成损失的，应予以赔偿甲方的全部损失。\n  6.2 除适用的法律法规另有明确规定或本协议另有明确规定外，任何一方违反本协议约定的，应承担违约责任（包括但不限于赔偿由此给对方造成的损失）。\n  7. 不可抗力\n  在适用的法律法规允许的最大限度内，甲方均不对由于互联网正常的设备维护，互联网络连接故障，电脑、通讯或其他系统的故障，黑客攻击，电力故障，罢工，暴乱，起义，骚乱，灾难性天气（包括但不限于火灾、洪水、风暴），爆炸，战争，政府行为，有权机关的命令或第三方的不作为而出现的不能服务、迟延服务、中断服务或其他按照本协议约定提供服务的情形等及其造成的损害、损失、成本、费用等承担任何责任。\n  8. 在线签约系统服务的终止\n  8.1 如商家自行终止在线签约申请，或商家的在线签约申请经甲方或甲方委托的第三方审核未通过的，则在线签约系统服务将自动终止。\n  8.2 如商家使用在线签约系统服务时，违反适用的法律法规规定或本协议规定的，甲方有权随时终止为商家提供在线签约系统服务。\n  8.3 除适用的法律法规另有明确规定或本协议另有明确规定外，在线签约系统服务被终止后，甲方仍有权在适用的法律法规允许的最大限度内保留商家基于在线签约系统产生的所有信息和记录；如商家在在线签约系统服务终止前存在违反适用的法律法规规定或本协议规定的行为，则甲方在在线签约系统服务终止后，仍可在适用的法律法规允许的最大限度内继续行使本协议所规定的全部权利。\n  9. 协议的期限、暂停和终止\n  9.1 不论本协议是否另有规定，乙方认可，甲方有权根据业务发展的需要在及时通知或通过其代理人通知乙方的情况下暂停或终止本协议、暂停或终止提供本协议项下的服务、或将甲方在本协议项下的权利或义务部分或全部转让给第三方，但甲方应努力妥善解决由此引起的相关事宜。\n  9.2 除本协议另有约定外，本协议的有效期至在线签约系统服务完成或终止时止。";

    [self.navigationController pushViewController:userVC animated:NO];
}

//商家承诺
- (IBAction)promiseProtocol:(id)sender {
    UserProtocolViewController * userVC = [UserProtocolViewController new];
    userVC.navTitle = @"商家承诺书";
    userVC.mutContent =@"重要须知：\n  本《承诺函》（以下简称“本承诺函”）是由商家（以下简称“乙方”或“商家”）向展富宝网站（即www.zavfb.com ，以下简称“展富宝网站”）的运营方即重庆展付卫网络技术有限公司（以下简称“甲方”）作出的关于在展富宝网络交易平台（以下简称“网络交易平台”）上展示、销售或提供商品或服务的承诺和保证。本承诺函作为甲乙双方签署的《展富宝网络交易平台服务协议》（以下简称“平台协议”）附件之一，为平台协议不可分割的一部分，与平台协议正文具有同等法律效力。在适用的法律法规允许的最大限度内，甲方有权根据情况不时地制定、修订、调整或变更本承诺函，并将提前至少7日公示并通知乙方。前述制定、修订、调整或变更后的承诺函一经甲方公示并通知乙方后，立即自动生效，成为平台协议的一部分；虽有前述约定，本承诺函生效后，如乙方不同意前述制定、修订、调整或变更后的承诺函，可自甲方公示并通知乙方之日起3个工作日内以通知方式向甲方提出异议，在此种情况下，平台协议（包括但不限于本承诺函）将于乙方通知之日起自动终止，且甲方对于该等终止不负任何违约责任或其他责任，乙方应与甲方协商平台协议终止事宜（包括但不限于款项结算事宜(如有) ）。如乙方未根据前述约定向甲方提出异议，即视为乙方接受前述制定、修订、调整、或变更后的承诺函；如乙方登录或继续使用展富宝网站相关账户（包括但不限于商家账户，下同），即视为乙方接受前述制定、修订、调整或变更后的承诺函。\n  本承诺函项下要求或允许给予的所有“公示”、“通知”、“公示并通知”、“同意”、“批准”、“许可”等应为书面形式，并应通过在展富宝网站公示、传真、电子邮件、专人派送、特快专递或挂号信发出。任何一方均可通过前述方式发出通知来改变其以后所有通知的投递地址。除非另有相反的明确规定，通知若以在展富宝网站公示形式发出，则送达时间应以展富宝网站最早公示之时为准；若以传真形式发出，则送达时间应以传真传送记录所显示之时间为准；若以电子邮件形式发出，则送达时间应以邮件进入收件方指定之电子邮件系统之时为准；若以专人派送或特快专递形式发出，则送达时间应以收件方签收之时间为准；若以挂号信形式发出，则送达时间应以邮局之发送单据为凭，自发送之日起七日为准。\n  本承诺函之签署、效力、解释和执行以及本协议项下争议之解决均适用中华人民共和国法律（为本协议之目的，不包括香港、澳门、台湾法律）。甲乙双方在签署、履行本承诺函中发生的争议或纠纷，应通过友好协商解决；协商不成的，任何一方有权将争议提交至甲方住所地人民法院诉讼解决。\n  甲方在此特别提醒乙方认真阅读、充分理解本承诺函各条款（对于本承诺函中以加粗字体显示的内容，应重点阅读），并请乙方审慎考虑并选择接受或不接受本承诺函。如果乙方一经选择“我已阅读、同意并接受”选项并点击“同意以上文件并继续”按钮（签署选项或按钮的具体表述可能会做适当调整），即表示其接受了本承诺函，并同意受本承诺函各项条款的约束。如果乙方不同意本承诺函中的任何规定，可以选择不予点击“我已阅读、同意并接受”选项或不予点击“同意以上文件并继续”按钮（签署选项或按钮的具体表述可能会做适当调整），在此种情况下，乙方未予接受平台协议，无法使用展富宝网络交易平台服务，亦无法登陆或使用相关账户。\n  本“重要须知”为本承诺函的组成部分。\n  鉴于国家和地方相关法律法规对消费者权益保护等问题的高度重视，以及网络交易平台对商家销售商品或提供服务质量和品质方面的严格要求，乙方特此向甲方作出如下郑重承诺：\n  1. 乙方确保严格遵守并全面履行甲乙双方签署的全部协议（包括但不限于平台协议）。\n  2. 乙方确认其商品或服务均已取得国家和地方法律法规及有权机关其他规定的合法有效的资质文件，均为正品，经合法正规渠道引进（包括但不限于取得合法有效真实完整的授权、进货手续完备(包括但不限于能够提供购销合同、购销发票等进货凭证)），能够合法在网络交易平台上展示、销售或提供；不存在任何假冒伪劣情形，商品信息真实、准确、合法、有效、完整，并不存在任何虚假宣传、错误宣传、夸大宣传的情形，并不存在任何违反国家和地方法律法规及有权机关其他规定的情形。\n  3. 乙方承诺已建立完善的商品采购、仓储、运输、配送、展示、销售等流程并具备相应运营能力（包括但不限于保障商品质量和及时配送的能力），保证商品配送条件符合商品说明书等规定的要求，且应与平台协议规定和乙方在网络交易平台上开设的店铺（以下简称“店铺”）上作出的承诺保持一致。乙方确保在商品采购、仓储、运输、配送、展示、乙方在店铺内的销售及其他运营环节均由乙方或乙方授权方进行；且，不论在哪个环节，商品质量和品质、包装、配送等不受任何非法、不合理或不当的影响。\n  4.乙方承诺具备成熟的线下实体店铺，在平台销售的基础上，具备线下体验服务的接待能力，同时保证线上线下提供的商品和服务的一致性。承诺线下实体店接受甲方的不定时的审查、监管。\n  5 乙方承诺严格遵守《中华人民共和国产品质量法》、《中华人民共和国消费者权益保护法》及其他法律、法规、部门规章和国家强制性标准规定的要求，销售或提供商品或服务，保障商品或服务真实、安全、有效，并提供售后服务。\n  6. 乙方承诺其在展示、销售或提供的商品或服务中未使用任何未获合法正规授权的品牌的商标、企业名称、商品信息描述、商品或品牌图片等（包括但不限于品牌的关键字），未出现任何违反甲方或任何他方的知识产权及其他合法权利（包括但不限于著作权、专利权、商标权、企业名称权、人身权利）的行为。\n  7. 乙方认可：为保障消费者权益，经甲方根据适用的法律法规规定、本协议约定、生效法律文书或行政处罚决定、顾客或任何他方投诉、或甲方查阅或审查乙方的注册资料、信息发布或商品或服务交易行为的情况等判断乙方应向顾客承担包括但不限于退货、退款、赔偿损失等消费者合法权益保障义务的，甲方有权选择直接扣除保证金的部分或全部，用于对于顾客的赔付；如保证金余额不足以支付的，乙方应根据甲方的要求及时补足，否则，由此造成的损失均由乙方全部承担且甲方有权选择从甲乙双方的结算款项（包括但不限于货款）中直接扣除相应金额并赔付顾客。适用前述约定的情形包括但不限于：\n  (1) 商品或服务出现质量问题；\n  (2) 商品或服务与宣传不符；\n  (3) 销售假冒伪劣商品等其他侵犯消费者权益的行为；\n  (4) 其他根据适用的法律法规规定、本协议约定、生效法律文书或行政处罚决定、顾客或任何他方投诉、或甲方查阅或审查乙方的注册资料、信息发布、或商品或服务交易行为的情况等应予以扣除保证金的情形。\n  8. 乙方认可并接受甲方基于维护市场良好秩序、保障消费者合法权益的目的，依照平台协议的规定对乙方商品或服务进行品质抽检或真假鉴定，甲方有权根据前述抽检或鉴定结果，依照平台协议的规定采取相应处理措施。对于经抽检证明存在质量瑕疵或经鉴定为假货的商品，抽检或鉴定所发生的所有费用均由乙方承担，且乙方认可甲方有权根据适用的法律法规的规定、平台协议及本承诺函的规定追究乙方的相关责任。\n  9. 乙方有义务依据适用的法律法规规定，向购买或接受其商品或服务的顾客开具合规的发票等销售凭证；并应就店铺实际成交之金额依法、及时、足额地向其所在地主管税务机关申报纳税。\n  10. 在适用的法律法规允许的最大限度内，与乙方展示、销售、提供商品或服务相关的全部事项（包括但不限于信息展示、售前服务、产品安全、产品质量、售后服务、配送、运输及运输风险、交货、发票开具等），以及由该等事项引发的任何争议、纠纷、诉讼、仲裁、处罚、投诉、索赔等（包括但不限于因乙方操作失误造成的系统自动退款等），均由乙方自行处理并负责承担全部法律责任（包括但不限于赔偿给顾客、甲方或任何他方造成的损失）。\n  11. 除本承诺函另有明确约定外，在适用的法律法规允许的最大限度内，如乙方违反本承诺函项下的任何规定（包括但不限于乙方商品或服务经甲方通过相关渠道确认或经相关媒体报道、政府部门检查等被认定为假冒伪劣商品或非来源于正规渠道），乙方将承担全部责任，与甲方无涉。如乙方违反本承诺函项下的任何承诺或本承诺函的任一承诺被甲方或任何他方发现不真实、不准确的，乙方同意甲方有权在适用的法律法规允许的最大限度内，采取下述部分或全部措施，乙方确认将严格遵循甲方的要求予以执行：\n  (1) 扣除乙方缴纳的部分或全部保证金；\n  (2) 冻结或扣除部分或全部甲乙双方之间的未结款项（包括但不限于乙方货款）；\n  (3) 删除部分或全部商品搜索、展示，删除、屏蔽、断开链接，监管店铺；\n  (4) 关闭店铺；\n  (5) 提前部分或全部终止平台协议；\n  (6) 临时或永久终止与乙方的部分或全部合作（不论该等合作是否基于本承诺函而产生）；\n  (7) 要求乙方承担赔偿责任或要求乙方支付不少于人民币壹佰万元的违约金；\n  (8) 根据平台协议规定采取的其他措施。\n  12. 除本承诺函另有明确规定外，在使用的法律法规允许的最大限度内，因乙方履行或不履行本承诺函给甲方或任何他方造成任何争议、纠纷、诉讼、仲裁、处罚、投诉、索赔的，均由乙方负责处理并承担全部责任（包括但不限于赔偿责任(包括但不限于赔偿因销售或提供假冒伪劣商品或服务或非正规渠道商品或服务给消费者造成的经济损失、给甲方造成的全部直接和间接损失)），与甲方无关";
    [self.navigationController pushViewController:userVC animated:NO];
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
