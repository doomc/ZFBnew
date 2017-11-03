//
//  iWantOpenStoreViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface iWantOpenStoreViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tf_VerCode;
@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UIButton *verCode_btn;
@property (weak, nonatomic) IBOutlet UIButton *NextPage_btn;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UIButton *address_btn;

@end
