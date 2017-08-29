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
@optional
/** 全选或者删除按钮点击事件 */
- (void)selectOrEditGoods:(UIButton *)sender;
/** 进入商店 */
- (void)enterShopStore;
/** 点击门店全选 按钮回调 */
- (void)shopStoreSelected:(NSInteger)sectionIndex;
/** 点击 编辑回调按钮 */
- (void)shopCarEditingSelected:(NSInteger)sectionIdx;
/** 进入店铺详情*/
- (void)enterStoreDetailwithStoreId:(NSInteger )storeId;


@end
@interface ShopCarSectionHeadViewCell : UITableViewCell

@property (nonatomic, strong) Shoppcartlist * storelist;

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


#pragma mark -  头部视图shopCarSectionHeadViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseStore_btn;//选择店铺
@property (weak, nonatomic) IBOutlet UIButton *editStore_btn;//编辑状态
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
@property (weak, nonatomic) IBOutlet UIButton *enterStore_btn;//进入店铺
@property (nonatomic,assign) NSInteger sectionIndex;//区头位置



@end
