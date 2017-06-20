//
//  AppraiseModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppraiseModel : NSObject

///评论id
@property (copy ,nonatomic)NSString *reciewsId;
///用户头像
@property (copy ,nonatomic)NSString *userAvatarImg;
///用户名字
@property (copy ,nonatomic)NSString *userName;
///多少时间之前
@property (copy ,nonatomic)NSString *befor;
///评论来源那个设备
@property (copy ,nonatomic)NSString *equip;
///评论等级
@property (copy ,nonatomic)NSString *goodsComment;
///评论内容
@property (copy ,nonatomic)NSString *reviewsText;
///评论图片的url
@property (copy ,nonatomic)NSString *reviewsImgUrl;

@property (copy,nonatomic) NSString * imgUrl;

@property (nonatomic,strong) UIImage *image;

@end
