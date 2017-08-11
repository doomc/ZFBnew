//
//  SalesAfterPopView.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  售后申请popView

#import <UIKit/UIKit.h>


@protocol SalesAfterPopViewDelegate <NSObject>

 

@end
@interface SalesAfterPopView : UIView

@property (nonatomic,assign) id <SalesAfterPopViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *deliveryArray;

@property (nonatomic,assign) NSInteger section;



@end
