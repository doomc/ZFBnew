//
//  AddressCommitOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Orderfixinfo,Cmgoodslist;
@interface AddressCommitOrderModel : NSObject

@property (nonatomic, strong) Orderfixinfo *orderFixInfo;

@property (nonatomic, copy) NSString *goodsAllMoney;


@property (nonatomic, strong) NSArray<Cmgoodslist *> *cmGoodsList;

@property (nonatomic, copy) NSString *goodsCountMoney;

@property (nonatomic, copy) NSString *deliveryFee;

@property (nonatomic, assign) NSInteger resultCode;



@end
@interface Orderfixinfo : NSObject

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *postAddressId;

@property (nonatomic, copy) NSString *contactUserName;

@property (nonatomic, copy) NSString *postAddress;

@property (nonatomic, copy) NSString *contactMobilePhone;



@end
@interface Cmgoodslist : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

