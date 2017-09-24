//
//  ShareNewGoodsCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareCommendModel.h"
@protocol ShareNewGoodsCellDelegate <NSObject>


/**
 点赞事件
 
 @param index 下标
 */
-(void)didClickZanAtIndex:(NSInteger)index;

//点图片查看详情
-(void)didClickPictureDetailAtIndex:(NSInteger)index;

@end
@interface ShareNewGoodsCell : UITableViewCell

@property (assign , nonatomic) id <ShareNewGoodsCellDelegate>delegate;

@property (assign, nonatomic) NSInteger indexRow;

@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;

//描述下面的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleBottomHeight;


@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;

///标签
@property (weak, nonatomic) IBOutlet UILabel *lb_tags;

///点赞数量
@property (weak, nonatomic) IBOutlet UIButton *zan_btn;
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_buyNum;


@property (strong,nonatomic) Recommentlist * recommend;
/**
 0未点赞 1已点赞
 */
@property (copy,nonatomic) NSString * isThumbed;

/**
 推荐新品编号
 */
@property (copy,nonatomic) NSString * recommentId;


@end
