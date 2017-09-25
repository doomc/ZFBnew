//
//  ZFCollectEditCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"

@class ZFCollectEditCell;
@protocol ZFCollectEditCellDelegate <NSObject>
@optional
///选择单个商品
- (void)goodsSelected:(ZFCollectEditCell *)cell isSelected:(BOOL)choosed;
///删除cell
- (void)deleteCell:(ZFCollectEditCell *)cell  ;


@end
@interface ZFCollectEditCell : UITableViewCell

@property (nonatomic,assign) id <ZFCollectEditCellDelegate> delegate;
 
@property (weak, nonatomic) IBOutlet UIImageView *img_editView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UIButton *selecet_btn;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) Cmkeepgoodslist *goodlist;
///收藏id
@property (assign, nonatomic) NSInteger  collectID;
///商品id
@property (copy, nonatomic) NSString * goodsID;

//门店收藏
@property (strong, nonatomic) Cmkeepgoodslist *storeList;
@property (copy, nonatomic) NSString * storeID;




@end
