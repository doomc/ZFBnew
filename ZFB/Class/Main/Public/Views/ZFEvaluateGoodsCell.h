//
//  ZFEvaluateGoodsCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TggStarEvaluationView.h"
#import "FSTextView.h"

@protocol ZFEvaluateGoodsCellDelegate <NSObject>

@required

/**
 上传图片数组

 @param uploadArr 图片数组
 */
-(void)uploadImageArray:(NSMutableArray *)uploadArr;

/**
 获取动态高度

 @param cellHeight cell高度
 */
-(void)reloadCellHeight:(CGFloat)cellHeight;

//获取textView中的值
-(void)getTextViewValues:(NSString *)textViewValues;

@end
@interface ZFEvaluateGoodsCell : UITableViewCell

@property (assign , nonatomic) id <ZFEvaluateGoodsCellDelegate> delegate;
//评分数
@property (weak, nonatomic) IBOutlet UILabel *lb_score;

@property (weak, nonatomic) IBOutlet TggStarEvaluationView *starView;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet FSTextView *textView;
//选择相册
@property (weak, nonatomic) IBOutlet UIView *pickerView;
//当前view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfConstraint;
//存放选取的图片数组
@property (nonatomic, strong) NSMutableArray * imgUrl_mutArray;

@property (nonatomic, assign) CGFloat cellHight;


@end
