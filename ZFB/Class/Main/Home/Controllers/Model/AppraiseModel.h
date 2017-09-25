//
//  AppraiseModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentData,Goodscommentlist,Findlistreviews;
@interface AppraiseModel : ResponseObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) CommentData *data;



@end

@interface CommentData : ResponseObject

@property (nonatomic, strong) Goodscommentlist *goodsCommentList;

@end

@interface Goodscommentlist : ResponseObject

@property (nonatomic, assign) NSInteger goodCommentNum;

@property (nonatomic, assign) NSInteger imgCommentNum;

@property (nonatomic, strong) NSArray<Findlistreviews *> *findListReviews;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger commentNum;

@property (nonatomic, assign) NSInteger lackCommentNum;

@end

@interface Findlistreviews : ResponseObject

@property (nonatomic, assign) NSInteger imgComment;

@property (nonatomic, copy) NSString *equip;

@property (nonatomic, assign) NSInteger serAttitude;

@property (nonatomic, assign) NSInteger deliverySpeed;

@property (nonatomic, assign) NSInteger readFlag;

@property (nonatomic, assign) NSInteger reviewsStatus;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger goodsComment;

@property (nonatomic, copy) NSString *modifyDate;

@property (nonatomic, copy) NSString *reviewsImgUrl;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *reviewsText;

@property (nonatomic, assign) NSInteger cmUserId;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) NSInteger mainReviewsId;

@property (nonatomic, assign) NSInteger reviewsId;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, copy) NSString *userAvatarImg;

@property (nonatomic, copy) NSString *attachImgUrl;

@property (nonatomic,strong) NSArray *evaluteImages;

@end

