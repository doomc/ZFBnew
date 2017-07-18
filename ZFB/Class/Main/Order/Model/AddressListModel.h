
//
//  AddressListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  选择地址列表

#import <Foundation/Foundation.h>


@class Addresslist,Useraddresslist;
@interface AddressListModel : NSObject


@property (nonatomic, strong) Addresslist *addressList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;


@end

@interface Addresslist : NSObject

@property (nonatomic, strong) NSArray<Useraddresslist *> *userAddressList;

@property (nonatomic, copy) NSString *responsetext;

@property (nonatomic, copy) NSString *status;

@end

@interface Useraddresslist : NSObject

@property (nonatomic, copy) NSString *contactMobilePhone;

@property (nonatomic, copy) NSString *contactUserName;

@property (nonatomic, assign) NSInteger defaultFlag;

@property (nonatomic, assign) NSInteger postAddressId;

@property (nonatomic, copy) NSString *replenish;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *postAddress;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) long long modifyDate;

@property (nonatomic, assign) NSInteger cmUserId;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *zipCode;

@end

