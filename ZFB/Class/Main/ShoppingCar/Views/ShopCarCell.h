//
//  ShopCarCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"
@protocol ShopCarCellDelegate <NSObject>

/** 选择按钮点击事件 */
- (void)cellSelectBtnClick:(UIButton *)sender;
/** 删除按钮点击事件 */
- (void)deleteShopGoodTouch:(UIButton *)sender;
/** 增减数量按钮点击事件 */
- (void)changeShopCount:(UIButton *)sender;
/** 手动输入数量 */
- (void)tableViewScroll:(UITextField *)textField;

@end
@interface ShopCarCell : UITableViewCell

@property (nonatomic, strong) ShopGoodslist * goodslist;

@property (nonatomic, weak) id<ShopCarCellDelegate>delegate;

/** cell编辑状态 */
@property (nonatomic, assign) BOOL shopCellEditState;
/** 选择按钮的选择状态 */
@property (nonatomic, assign) BOOL shopCellSelectBtnState;
/** 删除按钮的状态 */
@property (nonatomic, assign) BOOL shopCellDeleteBtnState;

/** 获取商品价格 */
- (NSInteger)getShopPrice;


@end
