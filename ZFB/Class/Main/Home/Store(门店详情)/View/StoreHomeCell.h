//
//  StoreHomeCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailHomeModel.h"

@protocol StoreHomeCellDelegate <NSObject>

-(void)didClickwitchOneBuyIndexPath:(NSIndexPath*)indexPath AndGoodId:(NSString * )goodId;

@end

@interface StoreHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_salePrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_storePrice;
@property (weak, nonatomic) IBOutlet UIButton *buyNow;
@property (assign, nonatomic) id <StoreHomeCellDelegate> delegate;
@property (strong, nonatomic)  GoodsExtendList * goodslist;
@property (copy, nonatomic)  NSString * currentGoodId;
@property (strong, nonatomic)  NSIndexPath * indexPath;


@end
