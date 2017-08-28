//
//  IMSearchResultViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, FriendType) {
    FriendTypeSingle,
    FriendTypeGroup,

};

@interface IMSearchResultViewController : BaseViewController

@property (nonatomic , assign) FriendType  friendType;

@property (nonatomic , copy) NSString * searchResult;

@end
