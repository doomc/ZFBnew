//
//  ShopCarSectionHeadViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"

@protocol ShopCarSectionHeadViewDelegate <NSObject>

/** 全选或者删除按钮点击事件 */
- (void)selectOrEditGoods:(UIButton *)sender;
/** 进入商店 */
- (void)enterShopStore;

@end
@interface ShopCarSectionHeadViewCell : UITableViewHeaderFooterView

@property (nonatomic, strong) ShoppingCarModel *carModel;

@property (nonatomic, weak)  id<ShopCarSectionHeadViewDelegate>delegate;
/** 设置选择按钮的tag */
@property (nonatomic, assign) NSInteger selectBtnTag;
/** 设置编辑按钮的tag */
@property (nonatomic, assign) NSInteger editBtnTag;
/** 设置全选按钮的状态 */
@property (nonatomic, assign) BOOL headerViewAllSelectBtnState;
/** 设置编辑按钮的状态 */
@property (nonatomic, assign) BOOL headerViewEditBtnState;
/** 设置编辑按钮的状态 */
@property (nonatomic, assign) BOOL hiddenEidtBtn;


@end
