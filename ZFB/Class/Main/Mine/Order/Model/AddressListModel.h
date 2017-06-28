
//
//  AddressListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Cmuserinfo;
@interface AddressListModel : NSObject

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<Cmuserinfo *> *cmUserInfo;

@property (nonatomic,assign) BOOL isChoosedDefaultesAddress;//选择默认地址



@end

@interface Cmuserinfo : NSObject

@property (nonatomic, copy) NSString *postAddressId;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *contactUserName;

@property (nonatomic, copy) NSString *contactMobilePhone;

@property (nonatomic, copy) NSString *postAddress;

@property (nonatomic, copy) NSString *defaultFlag;

 

@end

