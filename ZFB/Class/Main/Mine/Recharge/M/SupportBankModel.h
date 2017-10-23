//
//  SupportBankModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Base_Bank_List;
@interface SupportBankModel : ResponseObject
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<Base_Bank_List *> *base_bank_list;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface Base_Bank_List : ResponseObject

@property (nonatomic, copy) NSString *base_bank_log_url;

@property (nonatomic, assign) NSInteger base_bank_id;

@property (nonatomic, copy) NSString *base_bank_code;

@property (nonatomic, copy) NSString *base_bank_name;
@end

