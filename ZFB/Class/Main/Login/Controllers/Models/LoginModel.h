//
//  LoginModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginUserinfo;
@interface LoginModel : NSObject

@property (nonatomic, strong) LoginUserinfo *userInfo;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;
    
@end
@interface LoginUserinfo : NSObject

@property (nonatomic, copy) NSString *commissBalance;

@property (nonatomic, copy) NSString *accountBalance;

@property (nonatomic, copy) NSString *userKeyMd5;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *accid;

@end

