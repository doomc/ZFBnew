//
//  BankCardListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ResponseObject.h"

@class BankList;

@interface BankCardListModel : ResponseObject

@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSArray <BankList *> *bankList;

@end
@interface BankList : ResponseObject

@property (nonatomic, copy) NSString * bank_id;
@property (nonatomic, copy) NSString * bank_num;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * bank_name;
@property (nonatomic, copy) NSString * bank_img;
@property (nonatomic, copy) NSString * bank_type; //1,2,3银行卡类型


@end
