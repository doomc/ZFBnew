//
//  EditCommentModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EditCommentData,EditCommentList;

@interface EditCommentModel : ResponseObject

@property (nonatomic , strong) EditCommentData  * data;
 


@end

@interface EditCommentData : ResponseObject

@property (nonatomic , assign) NSInteger  num;
@property (nonatomic , strong) NSArray <EditCommentList *>  * commentList;

@end

@interface EditCommentList : ResponseObject

@property (nonatomic , copy) NSString  * content;
@property (nonatomic , copy) NSString  * thumb_img;
@property (nonatomic , assign) NSInteger   parent_id;
@property (nonatomic , copy) NSString  * parent_id_all;
@property (nonatomic , assign) NSInteger   topic_id;
@property (nonatomic , assign) NSInteger user_id;
@property (nonatomic , copy) NSString  * comment_date;
@property (nonatomic , assign) NSInteger   type;
@property (nonatomic , copy) NSString  * comment_img_url;
@property (nonatomic , assign) NSInteger like_num;
@property (nonatomic , assign) NSInteger comment_id;
@property (nonatomic , assign) NSInteger replyNum;
@property (nonatomic , assign) NSInteger ifLike;//是否点赞 1没有点赞 2 已点赞
@property (nonatomic , copy) NSString  * nickname;
@property (nonatomic , strong) NSArray  * replyList;

@end
