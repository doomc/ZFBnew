//
//  AccountModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ResponseObject.h"

@class accountData,Cashflowlist;
@interface AccountModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) accountData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface accountData : NSObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<Cashflowlist *> *cashFlowList;

@end

@interface Cashflowlist : NSObject

@property (nonatomic, copy) NSString *transaction_no;

@property (nonatomic, assign) NSInteger service_amount;

@property (nonatomic, assign) CGFloat transaction_amount;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *operation_account;

@property (nonatomic, assign) NSInteger flow_type;

@property (nonatomic, copy) NSString *target_account;

@property (nonatomic, assign) NSInteger pay_type;

@property (nonatomic, copy) NSString *logo_url;

@property (nonatomic, assign) NSInteger transaction_status;

@property (nonatomic, copy) NSString *cash_flow_num;

@property (nonatomic, copy) NSString *pay_mode_name;

@property (nonatomic, copy) NSString *object_name;

@property (nonatomic, copy) NSString *transfer_description;

@property (nonatomic, assign) NSInteger people_points;

@property (nonatomic, assign) NSInteger pay_mode;

@property (nonatomic, assign) NSInteger flowId;

@property (nonatomic, copy) NSString *delivery_address;

@property (nonatomic, assign) NSInteger flow_pay_type;

@property (nonatomic, copy) NSString *order_num;

@end

