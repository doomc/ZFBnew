//
//  BusinessSendOrderView.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BusinessSendOrderViewDelegate <NSObject>

/**
 商户进行针对于距离选择配送员派单
 
 @param deliveryId 配送员
 @param deliveryName 配送员名称
 @param deliveryPhone 配送手机号
 @param index 选择当前位置
 */
-(void)didClickPushdeliveryId:(NSString*)deliveryId
                 deliveryName:(NSString *)deliveryName
                deliveryPhone:(NSString *)deliveryPhone
                        Index:(NSInteger)index;

@end
@interface BusinessSendOrderView : UIView

@property (nonatomic,assign) id <BusinessSendOrderViewDelegate>delegate;

@property (nonatomic,strong) NSMutableArray *deliveryArray;



@end