//
//  GoodsParamCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoodsParamCellDelegate <NSObject>
@optional

-(void)didClickGoodsType:(GoodsParamType)type;


@end
@interface GoodsParamCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *btn_detail;
@property (weak, nonatomic) IBOutlet UIButton *btn_param;
@property (weak, nonatomic) IBOutlet UIButton *btn_promiss;
@property (assign, nonatomic) id <GoodsParamCellDelegate >delegate;
@property (assign, nonatomic) GoodsParamType goodsParamType;


@end
