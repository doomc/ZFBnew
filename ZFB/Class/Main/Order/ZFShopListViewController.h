//
//  ZFShopListViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^StoreAttchArrBlock)(NSMutableArray *attchArray);


@interface ZFShopListViewController : BaseViewController

@property (nonatomic,strong) NSMutableArray * userGoodsArray;///商品列表
@property (nonatomic,strong) NSMutableArray * userGoodsInfoJSON;

@property (nonatomic,copy) NSString * postAddressId;
@property (nonatomic,copy) StoreAttchArrBlock   attchBlock;
@property (nonatomic,strong) NSMutableArray  * storeAttachListArr;//存放备注的数组
@property (nonatomic,strong) NSMutableArray  * nameAarry;//存放备注的数组


 
@end
