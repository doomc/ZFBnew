//
//  ZFShopCarCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCarModel.h"

@class ZFShopCarCell;

@protocol ShoppingSelectedDelegate <NSObject>

@optional

//-(void)ChangeGoodsNumberCell:(ZFShopCarCell *)cell Number:(NSInteger)num;
// 商品的增加或者减少回调
- (void)addOrReduceCount:(ZFShopCarCell *)cell tag:(NSInteger)tag;
// 点击单个商品选择按钮回调
- (void)goodsSelected:(ZFShopCarCell *)cell isSelected:(BOOL)choosed;
// 点击门店全选 按钮回调
- (void)shopStoreSelected:(NSInteger)sectionIndex;
// 点击 编辑回调按钮
- (void)shopCarEditingSelected:(NSInteger)sectionIdx;
// 点击垃圾桶删除
- (void)deleteRabishClick:(ZFShopCarCell *)cell;

//进入店铺详情
- (void)enterStoreDetailwithStoreId:(NSInteger )storeId;

// 点击编辑规格按钮下拉回调
//- (void)clickEditingDetailInfo:(ZFShopCarCell *)cell;


@end

@interface ZFShopCarCell : UITableViewCell

@property (assign, nonatomic) id <ShoppingSelectedDelegate> selectDelegate;

@property (strong,nonatomic) ShopGoodslist  * goodlist;


#pragma mark -  头部视图shopCarSectionHeadViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseStore_btn;//选择店铺
@property (weak, nonatomic) IBOutlet UIButton *editStore_btn;//编辑状态
@property (weak, nonatomic) IBOutlet UIButton *enterStore_btn;//进入店铺
@property (nonatomic,assign) NSInteger sectionIndex;//区头位置



#pragma mark - 正常视图
@property (weak, nonatomic) IBOutlet UIView *normalBackView;
@property (weak, nonatomic) IBOutlet UIImageView *img_shopCar;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UIButton *add_btn;
@property (weak, nonatomic) IBOutlet UIButton *reduce_btn;
@property (weak, nonatomic) IBOutlet UITextField *tf_result;//加减出的结果
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;//左边选择按钮


#pragma mark - 编辑后的视图
@property (weak, nonatomic) IBOutlet UIView *editBackView;
@property (weak, nonatomic) IBOutlet UIButton *deldete_btn;
@property (weak, nonatomic) IBOutlet UILabel *editlb_title;
@property (weak, nonatomic) IBOutlet UILabel *editlb_price;
@property (weak, nonatomic) IBOutlet UIButton *editAdd_btn;
@property (weak, nonatomic) IBOutlet UIButton *editReduce_btn;
@property (weak, nonatomic) IBOutlet UITextField *editTf_result;//加减出的结果

@end
