//
//  iOpenStoreViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface iOpenStoreViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//输入框
@property (weak, nonatomic) IBOutlet UITextField *tf_storeName;
@property (weak, nonatomic) IBOutlet UITextField *tf_contactName;

//营业图片
@property (weak, nonatomic) IBOutlet UIImageView *licenseView;
//法人身份证
@property (weak, nonatomic) IBOutlet UIImageView *IDCardView;
//开户许可
@property (weak, nonatomic) IBOutlet UIImageView *openLicenceView;
//承诺书
@property (weak, nonatomic) IBOutlet UIImageView *letterOfCommitmentView;

//主题类型
@property (weak, nonatomic) IBOutlet UIButton *themeType_btn;//1级
@property (weak, nonatomic) IBOutlet UIButton *themeMan_btn;//2级

//地址
@property (weak, nonatomic) IBOutlet UIButton *address_btn;
@property (weak, nonatomic) IBOutlet UIButton *detailAddressBtn;

//提交审核
@property (weak, nonatomic) IBOutlet UIButton *commmit_btn;

@end
