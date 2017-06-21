//
//  AppraiseModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cmgoodscommentinfo;

@interface AppraiseModel : NSObject

@property (nonatomic, copy) NSString *lackCommentNum;

@property (nonatomic, copy) NSString *goodCommentNum;

@property (nonatomic, copy) NSString *imgCommentNum;

@property (nonatomic, copy) NSString *commentNum;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<Cmgoodscommentinfo *> *cmGoodsCommentInfo;

@end

@interface Cmgoodscommentinfo : NSObject

@property (nonatomic, copy) NSString *reciewsId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *reviewsText;

@property (nonatomic, copy) NSString *goodsComment;

@property (nonatomic, copy) NSString *equip;

@property (nonatomic, copy) NSString *reviewsImgUrl;

@property (nonatomic, copy) NSString *userAvatarImg;

@property (nonatomic, copy) NSString *befor;

@end

