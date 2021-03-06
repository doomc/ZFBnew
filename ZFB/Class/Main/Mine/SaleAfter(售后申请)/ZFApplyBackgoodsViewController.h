//
//  ZFApplyBackgoodsViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  申请退货

#import "BaseViewController.h"

@interface ZFApplyBackgoodsViewController : BaseViewController

@property (nonatomic , copy) NSString * goodsName;
@property (nonatomic , copy) NSString * goodCount;///商品个数
@property (nonatomic , copy) NSString * price;
@property (nonatomic , copy) NSString * img_urlStr;
@property (nonatomic , copy) NSString * postName;///联系人
@property (nonatomic , copy) NSString * postPhone;///联系电话

@property (nonatomic, copy) NSString * orderId;//订单ID
@property (nonatomic, copy) NSString * orderNum;//订单号
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * serviceType;///服务类型	否	 0 退货 1 换货
@property (nonatomic, copy) NSString * coverImgUrl;//	商品图片	否
@property (nonatomic, copy) NSString * orderGoodsId;///商品唯一编号

@property (nonatomic, copy) NSString * reason;///退货原因
@property (nonatomic, copy) NSString * storeId;
@property (nonatomic, copy) NSString * orderTime;//上传订单时间
@property (nonatomic, copy) NSString * storeName;///商店名称
@property (nonatomic, copy) NSString * userId;///关联账号id

@property (nonatomic, copy) NSString * skuId;///商品规格
//@property (nonatomic, copy) NSString * goodsProperties;///商品规格
@property (nonatomic, copy) NSString * problemDescr;///问题描述

@end
