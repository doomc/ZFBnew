//
//  FriendListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendsData,Userfeiendlist;
@interface FriendListModel : NSObject


@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) FriendsData *data;

@end
@interface FriendsData : NSObject

@property (nonatomic, strong) NSArray<Userfeiendlist *> *userFeiendList;

@end

@interface Userfeiendlist : NSObject

@property (nonatomic, copy) NSString *userUrl;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *accid;

@property (nonatomic, copy) NSString *userName;

@end

